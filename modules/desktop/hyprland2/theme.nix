{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.hyprland2;
  nerdfonts = (
    pkgs.nerdfonts.override {
      fonts = [
        #"Noto Sans"
        "Iosevka"
        "FiraCode"
        "Mononoki"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    }
  );

  theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  font = {
    name = "Noto Nerd Font";
    package = nerdfonts;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
in

{
  config = lib.mkIf cfg.enable {

    fonts = {

      packages = with pkgs; [
        cantarell-fonts
        font-awesome
        theme.package
        font.package
        cursorTheme.package
        iconTheme.package
        gnome.adwaita-icon-theme
        papirus-icon-theme
        iosevka-comfy.comfy-fixed
        noto-fonts-emoji
        noto-fonts
        font-awesome
        liberation_ttf # free corefonts-metric-compatible replacement
        ttf_bitstream_vera
        gelasio # metric-compatible with Georgia
        powerline-symbols
      ];

      fontDir.enable = true;

      fontconfig = {
        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "Iosevka Comfy Fixed" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    myhm =
      { ... }@hm:
      {
        home = {
          sessionVariables = {
            XCURSOR_THEME = cursorTheme.name;
            XCURSOR_SIZE = "${toString cursorTheme.size}";
          };
          pointerCursor = cursorTheme // {
            gtk.enable = true;
          };
          file = {
            ".local/share/themes/${theme.name}" = {
              source = "${theme.package}/share/themes/${theme.name}";
            };
            ".config/gtk-4.0/gtk.css".text = ''
              window.messagedialog .response-area > button,
              window.dialog.message .dialog-action-area > button,
              .background.csd{
                border-radius: 0;
              }
            '';
          };
        };

        gtk = {
          inherit font cursorTheme iconTheme;
          theme.name = theme.name;
          enable = true;
          gtk3.extraCss = ''
            headerbar, .titlebar,
            .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
              border-radius: 0;
            }
          '';
        };

        qt = {
          enable = true;
          platformTheme = "kde";
        };
      };
  };
}
