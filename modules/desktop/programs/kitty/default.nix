{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.kitty;
  username = config.modules.users.primaryUser.username;
  homeDirectory = config.modules.users.primaryUser.homeDirectory;
  withImpermanence = config.modules.impermanence.enable;
in
{
  options.modules.desktop.programs.kitty = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    home-manager.users."${username}" =
      { pkgs, config, ... }@hm:
      {
        home.file = {
          ".config/kitty/kitty.session" = {
            source = ./configs/kitty.session;
          };
          ".config/kitty/kitty-monitor.session" = {
            source = ./configs/kitty-monitor.session;
          };
        };

        home.packages = [ pkgs.kitty ];
        programs.kitty = {
          enable = true;
          theme = "Gruvbox Dark";
          font.name = "Iosevka Comfy Fixed";
          settings = {
            background_opacity = "0.90";
            font_size = "12";
            bold_font = "auto";
            italic_font = "auto";
            bold_italic_font = "auto";
            disable_ligatures = "never";
            cursor_blink_interval = "1";
            cursor_stop_blinking_after = "0.0";
            select_by_word_characters = "@-./_~?&=%+#";
            enable_audio_bell = "no";
          };
        };
      };
  };
}
