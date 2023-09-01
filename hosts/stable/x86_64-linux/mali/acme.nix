{
  lib,
  pkgs,
  config,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@***REMOVED***";
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
    #"mali" = {
    #  domain = "mali.int.***REMOVED***";
    #  extraDomainNames = [];
    #  group = "nginx";
    #  directory = "/persist/var/lib/acme/mali";
    #};
    "s3.data.***REMOVED***" = {
      domain = "s3.data.***REMOVED***";
      extraDomainNames = ["*.s3.data.***REMOVED***" "minio.data.***REMOVED***"];
      postRun = "systemctl reload nginx.service";
      group = "nginx";
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
