{ pkgs, ... }:

  let 
  	menu = pkgs.writeShellApplication {
		name = "launch-app";
		runtimeInputs = [pkgs.kickoff pkgs.kickoff-dot-desktop];
		text = builtins.readFile ./bin_nix/launch-app.sh;
	};
	mod = "Mod4";
  in {
	  wayland.windowManager.sway = { 
		enable = true;
		systemd = {
		  xdgAutostart = true;
		  # variables = [ "--all" ]; # TODO: check if importing PATH for xdg-desktop-portal is working
		};
		# config = null;
		# extraConfigEarly = "include ~/.config/sway/config";
		# extraConfig = "include ~/config/sway_config";
	  };

	  xdg.configFile."sway/config".target = "./sway_config";

	  programs = {
		waybar = {
		  enable = true; systemd.enable = true;
		  # style = ''@import "common.css";'';
		};
		# swaylock = { enable = true;
		#   package = if inputs ? osConfig then pkgs.swaylock else pkgs.hello;
		#   settings = {
		#     daemonize = true; scaling = "fill"; image = "~/images/lockscreen";
		#     ignore-empty-password = true; show-failed-attempts = true;
		#     inside-color = lib.mkForce "1e1e2eaa";
		#   };
		# };
	  };
  }

# # users.yara = {
# #     home.pointerCursor = {
# #       name = "Adwaita";
# #       package = pkgs.adwaita-icon-theme;
# #       size = 24;
# #       x11 = {
# #         enable = true;
# #         defaultCursor = "Adwaita";
# #       };
# # 	  sway.enable = true;
# #     };
# # };
#
