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
		};
		# signing = { #soon tm 
		#   key = "git@yara.blue";
		#   signByDefault = false;
		# };
	  };

	 fish = {
	   enable = true;
	   shellAbbrs = {
		 # Git abbreviations
		 "gau" = "git add --update";
		 "gcmsg" = "git commit -am";
		 "gcob" = "git checkout -b";
		 "gd" = "git diff";
		 "gst" = "git status";
		 "gp" = "git push";
	   };
		plugins = with pkgs.fishPlugins;
		let mkPlugin = p: { inherit (p) src; name = "${p.pname}"; }; in
		  (map mkPlugin [
			puffer # (!! !$ ..+ etc)
			done   # notify when long running command done
			fish-you-should-use
			colored-man-pages
			autopair # try pisces?
			sponge   # remove failed commands from history
		 ]);
	 };
	# soon
    jujutsu = {
      enable = true;
    };
  };
}
