{ inputs, config, pkgs, lib, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "yara";
  home.homeDirectory = "/home/yara";

  home.packages = [
  	pkgs.gammastep
	pkgs.atuin
  ];

# TODO not working...
  services.gammastep.settings = {
	  enable = true;
	  provider = "manual";
	  latitute = "52.1326";
	  longitute = "5.2913";
	  temperature = {
		  day = 6500;
		  night = 3500;
	  };
  };


  imports = [
  	./git.nix
	./nfs.nix
	./nvim.nix
  ];

  home.pointerCursor = {
	  gtk.enable = true;
	  x11.enable = true;
	  name = "WhiteSur-cursors";
	  package = pkgs.whitesur-cursors;
	  size = 24;
  };

  programs.atuin = {
	  enable = true;
	  enableBashIntegration = true;
	  enableFishIntegration = true;
  };

  programs.firefox = {
		enable = true;
		nativeMessagingHosts = [ pkgs.passff-host ];
		profiles.default = {
			id = 0;
			name = "default";
			isDefault = true;
			search = {
				force = true;
				default = "ddg";
				order = ["ddg" "google" ];
			};
			settings = {
				extensions.autoDisableScopes = 0;
				browser.search.defaultenginename = "ddg";
			};
			extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
				ublock-origin
				# TODO request adguard here https://gitlab.com/rycee/nur-expressions/-/issues
				leechblock-ng
				passff
				vimium-c

			];
		};
	};


  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/*" = "vipsdisp.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

	# xdg.portal = { enable = true;
	#      xdgOpenUsePortal = true;
	#      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
	#      config.common.default = "gtk"; # TODO: set per-interface portal
	#    };

    home.sessionVariables = {
      NIX_PATH = "nixpkgs=flake:nixpkgs";
      NIX_CONF_DIR = lib.mkDefault (config.home.homeDirectory + "/nix");
    };

	home.file = builtins.listToAttrs (map (path:
	  let f = lib.strings.removePrefix (inputs.self + "/dotfiles/") (toString path);
	  in {
		name = f ; value = {source = config.lib.file.mkOutOfStoreSymlink
		  (config.home.sessionVariables.NIX_CONF_DIR + "/dotfiles/" + f);};
	  }) (lib.filesystem.listFilesRecursive ./dotfiles)); # dotfiles dir is in the same directory this file

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
