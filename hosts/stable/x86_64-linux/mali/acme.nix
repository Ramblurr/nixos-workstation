{
  lib,
  pkgs,
  config,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@outskirtslabs.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates.acme-credentials.path;
      extraLegoFlags = ["--dns.resolvers=1.1.1.1:53"];
    };
  };

  sops.secrets."acmeSecrets/cloudflareDnsToken" = {
    sopsFile = ./secrets.sops.yaml;
    restartUnits = [];
  };

  sops.secrets."acmeSecrets/cloudflareZoneToken" = {
    sopsFile = ./secrets.sops.yaml;
    restartUnits = [];
  };

  sops.templates.acme-credentials.content = ''
    CF_DNS_API_TOKEN=${config.sops.placeholder."acmeSecrets/cloudflareDnsToken"}
    CF_ZONE_API_TOKEN=${config.sops.placeholder."acmeSecrets/cloudflareZoneToken"}
  '';
  security.acme.certs = {
    "mali" = {
      domain = "mali.int.socozy.casa";
      extraDomainNames = [];
      group = "nginx";
    };
    "s3" = {
      domain = "s3.data.socozy.casa";
      extraDomainNames = ["*.s3.data.socozy.casa"];
      group = "minio";
    };
  };

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}