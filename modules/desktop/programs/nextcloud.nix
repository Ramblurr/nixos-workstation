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
  cfg = config.modules.desktop.programs.nextcloud;
  username = config.modules.users.primaryUser.username;
  homeDirectory = config.modules.users.primaryUser.homeDirectory;
  withImpermanence = config.modules.impermanence.enable;
in
{
  options.modules.desktop.programs.nextcloud = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {

    environment.persistence."/persist" = mkIf withImpermanence {
      users.${username} = {
        directories = [
          ".config/Nextcloud"
          ".local/share/Nextcloud"
        ];
      };
    };
    myhm = {
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
  };
}
