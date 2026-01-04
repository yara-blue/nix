{ pkgs, lib, inputs, config, myOverlays, ... }: {

 	# docs at: https://wiki.nixos.org/wiki/WireGuard
	# https://discourse.nixos.org/t/wg-quick-issues-after-updating-to-25-05/65225/5
	# start with sudo systemctl start wg-quick-wg0

	# TODO much secrets management
	networking.wg-quick.interfaces = {
		wg0 = {
			autostart = false;
			address = ["10.2.0.2/32"];
			# listenPort = 51820;
			dns = ["10.2.0.1"];
			privateKeyFile = "/wg0_private_key";

			peers = [{ 
				publicKey = "lqb+ofGYNsfYfvGBefHDrYR6BdDrgoY6QwN4QF//gwc=";
				allowedIPs = ["0.0.0.0/0" ];
				endpoint = "169.150.196.65:51820";
				persistentKeepalive = 25;
			}];
		};
	};

	# NixOS firewall will block wg traffic because of rpfilter
	networking.firewall.checkReversePath = "loose";
	networking.firewall.allowedUDPPorts =
	[config.networking.wg-quick.interfaces.wg0.listenPort];

	# Exempt local network from tunnel
	systemd.network.networks.wg0.routingPolicyRules = [
		{
		  To = "192.168.0.0/24";
		  Priority = 9;
		}
	  ];

	environment.systemPackages = with pkgs; [		
		wireguard-tools
		protonvpn-gui # use this, wireguard setup above does 
					  # not work, no clue why
	];
}
