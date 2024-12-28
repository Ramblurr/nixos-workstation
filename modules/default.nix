{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./boot/zfs.nix
    ./desktop/browser/chromium.nix
    ./desktop/browser/firefox.nix
    ./desktop/dynamic-wallpaper.nix
    ./desktop/hyprland2/ags.nix
    ./desktop/hyprland2/dconf.nix
    ./desktop/hyprland2/default.nix
    ./desktop/hyprland2/hyprland-config.nix
    ./desktop/hyprland2/theme.nix

    ./desktop/hyprland3/dconf.nix
    ./desktop/hyprland3/default.nix
    ./desktop/hyprland3/hyprland-config.nix
    ./desktop/hyprland3/theme.nix
    ./desktop/hyprland3/anyrun.nix
    ./desktop/hyprland3/hyprpaper.nix
    ./desktop/hyprland3/dunst.nix
    ./desktop/kde.nix
    ./desktop/programs/1password.nix
    ./desktop/programs/aseprite.nix
    ./desktop/programs/calibre.nix
    ./desktop/programs/chrysalis.nix
    ./desktop/programs/discord.nix
    ./desktop/programs/element.nix
    ./desktop/programs/fritzing.nix
    ./desktop/programs/junction.nix
    ./desktop/programs/kdeconnect.nix
    ./desktop/programs/kicad.nix
    ./desktop/programs/cad.nix
    ./desktop/programs/kitty/default.nix
    ./desktop/programs/logseq.nix
    ./desktop/programs/musescore.nix
    ./desktop/programs/nextcloud.nix
    ./desktop/programs/nheko.nix
    ./desktop/programs/obs.nix
    ./desktop/programs/owncloud.nix
    ./desktop/programs/signal.nix
    ./desktop/programs/slack.nix
    ./desktop/programs/thunderbird.nix
    ./desktop/programs/yubico.nix
    ./desktop/random-apps.nix
    ./desktop/services/hacompanion.nix
    ./desktop/services/ha-shutdown.nix
    ./desktop/services/swhkd.nix
    ./desktop/wayland.nix
    ./desktop/xdg.nix
    ./dev/clojure/default.nix
    ./dev/fennel.nix
    ./dev/jetbrains/default.nix
    ./dev/k8s/default.nix
    ./dev/node/default.nix
    ./dev/python.nix
    ./dev/radicle.nix
    ./dev/random.nix
    ./editors/emacs/default.nix
    ./editors/vim.nix
    ./editors/vscode/default.nix
    ./firewall/default.nix
    ./hardware/misc.nix
    ./hardware/pipewire.nix
    ./hardware/ryzen.nix
    ./impermanence/default.nix
    ./networking/default.nix
    ./networking/systemd-netns.nix
    ./networking/systemd-netns-private.nix
    ./security/default.nix
    ./server/smtp-external-relay.nix
    ./server/virtd/default.nix
    ./services/actual-budget.nix
    ./services/soju.nix
    ./services/archivebox.nix
    ./services/attic-watch-store.nix
    ./services/atuin-sync.nix
    ./services/authentik-module.nix
    ./services/authentik.nix
    ./services/borgmatic.nix
    ./services/calibre.nix
    ./services/calibre-web.nix
    ./services/davis.nix
    ./services/docker.nix
    ./services/echo-server.nix
    ./services/flatpak.nix
    ./services/forgejo.nix
    ./services/git-archive.nix
    ./services/github-runner.nix
    ./services/haproxy.nix
    ./services/home-dl.nix
    ./services/influxdb.nix
    ./services/ingress.nix
    ./services/ingress-options.nix
    ./services/invoiceninja.nix
    ./services/linkding.nix
    ./services/mariadb.nix
    ./services/matrix-discord.nix
    ./services/matrix-irc.nix
    ./services/matrix-synapse.nix
    ./services/matrix-synapse-postgres.nix
    ./services/microvm/default.nix
    ./services/ocis.nix
    ./services/onepassword-connect.nix
    ./services/paperless.nix
    ./services/plex.nix
    ./services/podman.nix
    ./services/postgresql.nix
    ./services/printing.nix
    ./services/roon-server.nix
    ./services/sshd.nix
    ./services/tautulli.nix
    ./services/zfs-backup-check.nix
    ./shell/aria2.nix
    ./shell/attic.nix
    ./shell/atuin.nix
    ./shell/direnv.nix
    ./shell/ffsend.nix
    ./shell/git.nix
    ./shell/gpg-agent.nix
    ./shell/htop/default.nix
    ./shell/mpv.nix
    ./shell/random.nix
    ./shell/ssh/default.nix
    ./shell/tmux.nix
    ./shell/zoxide.nix
    ./shell/zsh/default.nix
    ./users/default.nix
    ./vpn/mullvad.nix
    ./vpn/tailscale.nix
    ./nix.nix
    ./globals.nix
    #./secrets.nix
    ./secrets2.nix
    ./meta.nix
    ./zfs-attrs.nix
    ./sops.nix
    ./node.nix
  ];
}
