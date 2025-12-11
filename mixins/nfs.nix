# some info https://github.com/NixOS/nixpkgs/issues/72722

{ pkgs, lib, inputs, config, myOverlays, ... }: 

{
	networking.hosts = {
		"192.168.1.15" = [ "asgard" ];
	};

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
		Static = { # TODO automate this bit?
			"yara/work@YGGDRASIL" = "yara";
		};
	};

	fileSystems."/home/yara/Music" = {
		device = "asgard:/srv/music";
		fsType = "nfs4";
	};

	# TODO cache and store (agenix?) and move into place on rebuild
	# sudo kadmin -p yara/admin -q "addprinc -randkey nfs/<host>" 
	# sudo kadmin -p yara/admin -q "ktadd nfs/<host>" 
	# sudo kadmin -p yara/admin -q "addprinc <local username>" 
	# sudo kadmin -p yara/admin -q "ktadd <local username>" 
}
