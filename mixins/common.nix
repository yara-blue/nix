{ pkgs, lib, inputs, config, myOverlays, ... }: {
	users.users.yara = {
		isNormalUser = true;
		extraGroups = [ "yara" "wheel" ];
		initialPassword = "changethis";
		linger = true;
	};
	users.defaultUserShell = pkgs.fish;

	programs = {
		fish.enable = true;
	};


	environment.systemPackages = with pkgs; [
		nix-output-monitor
		home-manager
	];

  nixpkgs = { overlays = myOverlays; config.allowUnfree = true; };
}
