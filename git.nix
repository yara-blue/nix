{ pkgs, ... }: {

  home.shell.enableFishIntegration = true;

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

	alacritty.theme = "solarized_light";

	  git = {
		enable = true;
		settings = {
			user.name = "Yara";
			user.email = "git@yara.blue";
			rerere.enable = true;
			pull.rebase = true;
		};
		ignores = [
			".direnv"
		];
		# signing = { #soon tm
		#   key = "git@yara.blue";
		#   signByDefault = false;
		# };
	  };

		direnv = {
 			enable = true;
		};
	 fish = {
	   enable = true;
		plugins = with pkgs.fishPlugins;
		let mkPlugin = p: { inherit (p) src; name = "${p.pname}"; }; in
		  (map mkPlugin [
			puffer # (!! !$ ..+ etc)
			done   # notify when long running command done
			fish-you-should-use
			colored-man-pages
			autopair # try pisces?
			# sponge   # remove failed commands from history
		 ]);
	 };
	# soon
    jujutsu = {
      enable = true;
      settings.user = {
        email = "git@yara.blue";
        name = "Yara";
		behavior = "own";
		backend = "gpg";
		# yubikey backed signing subkey
		key = "12A0067B454A920F";
      };
    };
  };
}
