{ pkgs, lib, inputs, config, myOverlays, home-manager, ... }: {

	users.users.yara.isNormalUser = true;
	users.defaultUserShell = pkgs.fish;

	programs = {
		fish.enable = true;
	};

	environment.systemPackages = with pkgs; [
		nix-output-monitor
	];

	fonts.packages = with pkgs; [
	  noto-fonts
	  noto-fonts-cjk-sans
	  noto-fonts-color-emoji
	  liberation_ttf
	  fira-code
	  fira-code-symbols
	  mplus-outline-fonts.githubRelease
	  dina-font
	  proggyfonts
	];

  nixpkgs = { overlays = myOverlays; config.allowUnfree = true; };
}
