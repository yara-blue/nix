{ pkgs, hostname, ... }: 

let 
	user = {
		"work" = "yara-work";
		"abydos" = "yara";
	}."${hostname}";
in {
	systemd.user.enable = true;

	systemd.user.services.kerberos_mount = {
		# enable = true;
		Unit = {
			description = "Initializes, caches and renews Kerberos tickets";
			after = [ "default.target" ];
		};
		Install = {
			wantedBy = [ "default.target" ];
		};

		Service = {
			Type = "exec";
			RemainAfterExit = "yes";
			ExecStart = ''${pkgs.kstart}/bin/k5start \
				# run in daemon mode, recheck ticket every  30 minutes \
				-K 30 \
				# authenticate using keytab rather then asking for a password \
				-f %h/.local/keytab \
				# store this file as ticket cache \
				-k /tmp/krb5cc_%U \
				# principle to get tickets for \
				${user}'';
		};
	};
}
