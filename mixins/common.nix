{ pkgs, lib, inputs, config, myOverlays, home-manager, ... }: {

	users.users.yara.isNormalUser = true;
	users.defaultUserShell = pkgs.fish;

	programs = {
		fish.enable = true;
	};

	environment.shellAliases = {
	 # Git abbreviations
	 "gau" = "git add --update";
	 "ga" = "git add";
	 "gcmsg" = "git commit -am";
	 "gcob" = "git checkout -b";
	 "gd" = "git diff";
	 "gst" = "git status";
	 "gp" = "git push";
	 "gpf" = "git push --force-with-lease";

	 # other
	 "v" = "nvim";
   };

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

	  environment.sessionVariables = {
		VISUAL  = "zed-editor";
		EDITOR = "nvim";
	  };

	  nixpkgs = { overlays = myOverlays; config.allowUnfree = true; };
	  # only enables it for sudo for some reason...
	  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
