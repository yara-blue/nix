
{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		grim # screenshot functionality
		slurp # screenshot functionality
		wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

		hyprpicker # color picker
		kooha # screen recording

		rwaybar
		kickoff
		kickoff-dot-desktop

		# broken, needs to be build with nightly
		# for now manually installed
		# break-enforcer

		alsa-utils


		tuigreet
	];

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

}

