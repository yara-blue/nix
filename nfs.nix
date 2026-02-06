{ pkgs, hostname, ... }:

# kerberos tooling is super annoying so we can not really automate this further
# easily. This just gets you the parts so you do not need to do kinit every
# time.
#
# You'll still need to do some of: https://yara.blue/posts/secure_nfsv4/
# See mixins/nfs.nix for more kerberos setup, like id mapping and the actual
# mounting


let
	kerberos_principle = {
		"work" = "yara-work";
		"abydos" = "yara";
	}."${hostname}";
in {
	systemd.user.enable = true;

	systemd.user.services.kerberos_mount = {
		Unit = {
			Description = "Initializes, caches and renews Kerberos tickets";
			After = [ "default.target" ];
		};
		Install = {
			WantedBy = [ "default.target" ];
		};

		Service = {
			Type = "exec";
			RemainAfterExit = "yes";
			ExecStart = ''${pkgs.kstart}/bin/k5start \
				# run in daemon mode, recheck ticket every  30 minutes \
				-K 30 \
				# authenticate using keytab rather then asking for a password \
				-f /run/agenix/keytab \
				# store this file as ticket cache \
				-k /tmp/krb5cc_%U \
				# principle to get tickets for \
				${kerberos_principle}'';
		};
	};
}
