{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.services.sshd;
  withImpermanence = config.modules.impermanence.enable;
in
{
  options.modules.services.sshd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    permitRootLogin.enable = lib.mkEnableOption "";
  };
  config = mkIf cfg.enable {
    # Should exist already as it is used for sops bootstrapping
    # sops.secrets.ssh_host_ed25519_key = {
    #   path = "/persist/etc/ssh/ssh_host_ed25519_key";
    # };

    sops.secrets.ssh_host_ed25519_key_pub = {
      path = "${lib.optionalString withImpermanence "/persist"}/etc/ssh/ssh_host_ed25519_key.pub";
    };
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkForce (if cfg.permitRootLogin.enable then "without-password" else "no");
        PasswordAuthentication = false;
        StreamLocalBindUnlink = true;
      };
      hostKeys = [
        {
          path = "${lib.optionalString withImpermanence "/persist"}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    environment.persistence."/persist" = mkIf withImpermanence {
      files = [ "/root/.ssh/known_hosts" ];
    };
  };
}
