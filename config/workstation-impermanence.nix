{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.impermanence;
  username = config.modules.users.primaryUser.username;
in
{
  environment.persistence."/persist" = {
    users.${username} = {
      directories = [
        "nixcfg"
        "docs"
        "downloads"
        "src"
        "sync"
        "vendor"
        "work"
        ".cache/audacity"
        ".cache/gimp"
        ".cache/inkscape"
        ".cache/virt-manager"
        ".config/audacity"
        ".config/easyeffects"
        ".config/sops"
        ".config/GIMP"
        ".config/gnupg"
        ".config/inkscape"
        ".config/Morgen"
        ".config/OpenSCAD"
        ".config/PrusaSlicer"
        ".config/PrusaSlicer-alpha"
        ".config/qobuz-dl"
        ".config/rclone"
        ".config/Zeal"
        ".local/bin"
        ".local/share/keyrings"
        ".local/share/audacity"
        ".local/share/fonts"
        ".local/share/krita"
        ".local/share/Zeal"
        ".local/share/OpenSCAD"
        ".local/state/audacity"

        ".config/gtk-3.0" # fuse mounted from /nix/dotfiles/Plasma/.config/gtk-3.0
        ".config/gtk-4.0" # to /home/$USERNAME/.config/gtk-3.0
        ".config/KDE"
        ".config/kde.org"
        ".config/plasma-workspace"
        ".config/xsettingsd"
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/baloo"
        ".local/share/kactivitymanagerd"
        ".local/share/sddm"
        ".local/share/gwenview"
        ".local/share/dolphin"
        ".local/share/okular"
        ".kde"
        ".local/share/digikam"
        ".cache/digikam"
      ];
      files = [

        ".config/digikamrc"
        ".config/digikam_systemrc"
        ".config/akregatorrc"
        ".config/baloofileinformationrc"
        ".config/bluedevilglobalrc"
        ".config/device_automounter_kcmrc"
        ".config/dolphinrc"
        ".config/filetypesrc"
        ".config/gtkrc"
        ".config/gtkrc-2.0"
        ".config/gwenviewrc"
        ".config/kactivitymanagerd-pluginsrc"
        ".config/kactivitymanagerd-statsrc"
        ".config/kactivitymanagerd-switcher"
        ".config/kactivitymanagerdrc"
        ".config/katemetainfos"
        ".config/katerc"
        ".config/kateschemarc"
        ".config/katevirc"
        ".config/kcmfonts"
        ".config/kcminputrc"
        ".config/kconf_updaterc"
        ".config/kded5rc"
        ".config/kdeglobals"
        ".config/kgammarc"
        ".config/kglobalshortcutsrc"
        ".config/khotkeysrc"
        ".config/kmixrc"
        ".config/konsolerc"
        ".config/kscreenlockerrc"
        ".config/ksmserverrc"
        ".config/ksplashrc"
        ".config/ktimezonedrc"
        ".config/kwinrc"
        ".config/kwinrulesrc"
        ".config/kxkbrc"
        ".config/partitionmanagerrc"
        ".config/plasma-localerc"
        ".config/plasma-nm"
        ".config/plasma-org.kde.plasma.desktop-appletsrc"
        ".config/plasmanotifyrc"
        ".config/plasmarc"
        ".config/plasmashellrc"
        ".config/PlasmaUserFeedback"
        ".config/plasmawindowed-appletsrc"
        ".config/plasmawindowedrc"
        ".config/powermanagementprofilesrc"
        ".config/spectaclerc"
        ".config/startkderc"
        ".config/systemsettingsrc"
        #".config/Trolltech.conf"
        ".config/user-dirs.locale"
        ".local/share/krunnerstaterc"
        ".local/share/user-places.xbel"
        #".local/share/user-places.xbel.bak"
        #".local/share/user-places.xbel.tbcache"
      ];
    };
  };
}
