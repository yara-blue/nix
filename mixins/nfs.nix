# some info https://github.com/NixOS/nixpkgs/issues/72722

{
  pkgs,
  lib,
  hostname,
  ...
}:

let
  kerberos_principle =
    {
      "work" = "yara-work";
      "abydos" = "yara";
    }
    ."${hostname}";
in
{
  security.krb5 = {
    enable = true;
    settings = {
      libdefaults = {
        default_realm = "YGGDRASIL";
        dns_lookup_realm = "false";
        dns_lookup_kdc = "false";
      };
      domain_realm = {
        "yggdrasil" = "YGGDRASIL";
      };
      realms = {
        "YGGDRASIL" = {
          admin_server = "asgard";
          kdc = "asgard";
        };
      };
    };
  };

  services.nfs.idmapd.settings = {
    General = {
      Verbosity = "0";
      Domain = "yggdrasil";
    };
    Mapping = {
      Nobody-User = "nobody";
      Nobody-Group = "nogroup";
    };
    Translation = {
      Method = lib.mkForce "static";
      GSS-method = lib.mkForce "static";
    };
    Static = {
      "${kerberos_principle}@YGGDRASIL" = "yara";
    };
  };

  fileSystems."/home/yara/Music" = {
    device = "asgard:/srv/music";
    fsType = "nfs4";
  };

  environment.systemPackages = with pkgs; [
    kstart
  ];

  # keytab.age for user yara, see https://yara.blue/posts/secure_nfsv4/
  # automount section on how to create it
  age.secrets.keytab = {
	  owner = "yara";
	  group = "users";
	  mode = "400";
	  rekeyFile = ./. + "/../secrets/keytab.age";
  };
}
