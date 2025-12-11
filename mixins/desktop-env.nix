
{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		grim # screenshot functionality
		slurp # screenshot functionality
		swaybg # wallpaper
		wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

		hyprpicker # color picker
		kooha # screen recording

		waybar
		kickoff
		kickoff-dot-desktop

		break-enforcer

		alsa-utils

		tuigreet
	];


	# environment.pathsToLink = [
	# 	"/share/applications"
	# 	"/share/xdg-desktop-portal"
	# ];

  services.break-enforcer.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

	# stores secrets in pass password store
	services.passSecretService.enable = true;
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # xdg = {
  # portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-wlr
  #     xdg-desktop-portal-gtk
  #   ];
  # };
# };

}

