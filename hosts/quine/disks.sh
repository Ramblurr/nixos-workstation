#!/usr/bin/env bash

#
# NixOS install script synthesized from:
#
#   - https://gist.github.com/mx00s/ea2462a3fe6fdaa65692fe7ee824de3e
#   - Erase Your Darlings (https://grahamc.com/blog/erase-your-darlings)
#   - OpenZFS NixOS manual (https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/0-overview.html)
#   - ZFS Datasets for NixOS (https://grahamc.com/blog/nixos-on-zfs)
#   - NixOS Manual (https://nixos.org/nixos/manual/)
#   - https://gist.github.com/bobberb/025043a3897ab149a268fff1dd0c0082
#   - https://github.com/dr460nf1r3/dr460nixed/blob/d958facca7d2efd3fcf7803ecc372f56b84b7042/hosts/slim-lair/disks.sh#L11
#   - https://gist.github.com/lucasvo/35e0745b72dd384dcb9b9ee5bae5fecb
#
#
# Features:
#  - UEFI (GPT) partitioning
#  - Un-encrypted /boot
#  - Encrypted SWAP
#  - Encrypted ZFS root (using native zfs encryption)
#  - Single passphrase entry to unlock (actual encryption key is stored in the 2nd partition)
#  - ZFS datasets for /, /home, /persist (for use with impermanence)
#  - SSH authorized key auto added
#
# You must edit the script and set a view variables. The script must also be executed as root.
#
# Example: `sudo ./install.sh`
#

set -euo pipefail


DISK=changeme # e.g, nvme0n1
SWAPSIZE="72G"

################################################################################

export COLOR_RESET="\033[0m"
export RED_BG="\033[41m"
export BLUE_BG="\033[44m"

function err {
    echo -e "${RED_BG}$1${COLOR_RESET}"
}

function info {
    echo -e "${BLUE_BG}$1${COLOR_RESET}"
}

################################################################################


if ! [[ "$DISK" == "changeme" ]]; then
    err "You haven't configured the script. Please edit the script and set the variables."
    exit 1
fi

export DISK_PATH="/dev/${DISK}"

if ! [[ -b "$DISK_PATH" ]]; then
    err "Invalid argument: '${DISK_PATH}' is not a block special file"
    exit 1
fi


if [[ "$EUID" -gt 0 ]]; then
    err "Must run as root"
    exit 1
fi

export ZFS_POOL="rpool"

# ephemeral datasets
export ZFS_ENCRYPTED="${ZFS_POOL}/encrypted"
export ZFS_LOCAL="${ZFS_ENCRYPTED}/local"
export ZFS_DS_ROOT="${ZFS_LOCAL}/root"
export ZFS_DS_NIX="${ZFS_LOCAL}/nix"

# persistent datasets
export ZFS_SAFE="${ZFS_ENCRYPTED}/safe"
export ZFS_DS_HOME="${ZFS_SAFE}/home"
export ZFS_DS_PERSIST="${ZFS_SAFE}/persist"

export ZFS_BLANK_SNAPSHOT="${ZFS_DS_ROOT}@blank"

################################################################################

info "Running the UEFI (GPT) partitioning"

blkdiscard -f "$DISK_PATH"
sgdisk --zap-all "$DISK_PATH"
sgdisk --clear  --mbrtogpt "$DISK_PATH"

# boot
sgdisk -n 0:1M:+513M -t 0:EF00 "$DISK_PATH"
# cryptkey - stores the encryption key
sgdisk -n 0:0:+64M -t 0:8309 "$DISK_PATH"
# swap
sgdisk -n 0:0:+${SWAPSIZE} -t 0:8200 "$DISK_PATH"
# zfs
sgdisk -n 0:0:0 -t 0:EF00 "$DISK_PATH"

export BOOT="${DISK_PATH}p1"
export CRYPTKEY="${DISK_PATH}p2"
export SWAP="${DISK_PATH}p3"
export ZFS="${DISK_PATH}p4"

partprobe "$DISK_PATH"
sleep 1

info "Formatting boot & swap partition ..."
mkfs.vfat -n boot "$BOOT"

info "Formatting cryptkey partition"
echo "changeme" | cryptsetup luksFormat --label cryptkey "${CRYPTKEY}" -
echo "changeme" | cryptsetup open "${CRYPTKEY}" cryptkey -

info "Generating encryption key"
echo "" > newline
dd if=/dev/zero bs=1 count=1 seek=1 of=newline
dd if=/dev/urandom bs=32 count=1 | od -A none -t x | tr -d '[:space:]' | cat - newline > hdd.key
dd if=hdd.key of=/dev/mapper/cryptkey
dd if=/dev/mapper/cryptkey bs=64 count=1

info "Formatting encrypted swap partition ..."
echo "changeme" | cryptsetup luksFormat --label cryptswap --key-file=/dev/mapper/cryptkey --keyfile-size=64 "" -
echo "changeme" | cryptsetup open --key-file=/dev/mapper/cryptkey --keyfile-size=64 "$SWAP" cryptswap -

mkswap /dev/mapper/cryptswap
swapon /dev/mapper/cryptswap

info "Creating '$ZFS_POOL' ZFS pool for '$ZFS' ..."
# we do not encrypt the root pool, so we leave open the option
# to add other un-encrypted datasets later
zpool create \
    -O acltype=posixacl \
    -O compression=zstd \
    -O normalization=formD \
    -O xattr=sa \
    -f $ZFS_POOL $ZFS

zpool set autotrim=on $ZFS_POOL

info "Creating '$ZFS_ENCRYPTED' ZFS pool for '$ZFS' ..."
zfs create \
    -p \
    -o mountpoint=legacy \
    -o encryption=aes-256-gcm \
    -O keyformat=hex \
    -O keylocation=file:///dev/mapper/cryptkey \
    "$ZFS_DS_ROOT"

info "Creating '$ZFS_DS_ROOT' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_ROOT"

info "Configuring extended attributes setting for '$ZFS_DS_ROOT' ZFS dataset ..."
zfs set xattr=sa "$ZFS_DS_ROOT"

info "Configuring access control list setting for '$ZFS_DS_ROOT' ZFS dataset ..."
zfs set acltype=posixacl "$ZFS_DS_ROOT"

info "Creating '$ZFS_BLANK_SNAPSHOT' ZFS snapshot ..."
zfs snapshot "$ZFS_BLANK_SNAPSHOT"

info "Mounting '$ZFS_DS_ROOT' to /mnt ..."
mount -t zfs "$ZFS_DS_ROOT" /mnt

info "Mounting '$BOOT' to /mnt/boot ..."
mkdir -p /mnt/boot
mount -t vfat "$BOOT" /mnt/boot

info "Creating '$ZFS_DS_NIX' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_NIX"

info "Disabling access time setting for '$ZFS_DS_NIX' ZFS dataset ..."
zfs set atime=off "$ZFS_DS_NIX"

info "Mounting '$ZFS_DS_NIX' to /mnt/nix ..."
mkdir -p /mnt/nix
mount -t zfs "$ZFS_DS_NIX" /mnt/nix

info "Creating '$ZFS_DS_HOME' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_HOME"

info "Mounting '$ZFS_DS_HOME' to /mnt/home ..."
mkdir -p /mnt/home
mount -t zfs "$ZFS_DS_HOME" /mnt/home

info "Creating '$ZFS_DS_PERSIST' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_PERSIST"

info "Mounting '$ZFS_DS_PERSIST' to /mnt/persist ..."
mkdir -p /mnt/persist
mount -t zfs "$ZFS_DS_PERSIST" /mnt/persist

info "Permit ZFS auto-snapshots on ${ZFS_SAFE}/* datasets ..."
zfs set com.sun:auto-snapshot=true "$ZFS_DS_HOME"
zfs set com.sun:auto-snapshot=true "$ZFS_DS_PERSIST"

info "Done!"
echo
info "Now proceed with run install.sh"
