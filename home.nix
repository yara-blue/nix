{
  inputs,
  config,
  pkgs,
  hostname,
  lib,
  stylix,
  ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "yara";
  home.homeDirectory = "/home/yara";

  home.packages = [
    pkgs.gammastep
    pkgs.atuin
  ];

  services.gammastep.settings = {
    enable = true;
    provider = "manual";
    latitude = "52.1326";
    longitude = "5.2913";
    temperature = {
      day = 6500;
      night = 3500;
    };
  };

  imports = [
    inputs.agenix-rekey.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.playground.homeModules.default
    ./home/git.nix
    ./home/nfs.nix
    ./home/nvim.nix
    ./home/eza_theme.nix
    ./home/vim_theme.nix
    ./home/todoman.nix
  ];

  # keys to use for decryption, needed since mine are not named like id_rsa.pub
  age.identityPaths =
    let
      id =
        {
          "work" = "${config.home.homeDirectory}/.ssh/abydos";
          "abydos" = "${config.home.homeDirectory}/.ssh/abydos";
        }
        ."${hostname}";
    in
    [ id ];
  age.rekey =
    let
      yubikey1 = ./age-yubikey-identity-1b1c41c4.pub;
      yubikey2 = ./age-yubikey-identity-3035da2f.pub;
      # These must be keys readable to the user. These are not system keys like
      # for the agenix rekey setup in NixOs (mixins/common.nix)
      hostPubkey =
        {
          # TODO replace this key with the laptop one
          "work" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvUWV6S+4jU7ilsQ3kNR05VjyAh86tNm4WuUcP5Rq8M yara@abydos";
          "abydos" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvUWV6S+4jU7ilsQ3kNR05VjyAh86tNm4WuUcP5Rq8M yara@abydos";
        }
        ."${hostname}";
    in
    {
      inherit hostPubkey;
      masterIdentities = [
        yubikey1
        yubikey2
      ];
      storageMode = "local";
      localStorageDir = ./. + "/secrets/home/rekeyed/${hostname}/${config.home.username}";
    };

  home.pointerCursor.enable = true;

  stylix.cursor.package = pkgs.rose-pine-cursor;
  stylix.cursor.name = "BreezeX-RosePineDawn-Linux"; # dark: BreezeX-RosePine-Linux
  stylix.cursor.size = 24;
  stylix.targets = {
    # native neovim themes better (highlight groups & more shades)
    neovim.enable = false;
    alacritty.fonts.override = {
      size = 20; # I like it big
    };
    firefox.profileNames = [ "default" ];
    waybar.opacity.override = {
      desktop = 0.5;
    };
    # todo fix theming for light themes
    # https://github.com/nix-community/stylix/pull/365/changes
    nixcord.enable = false;
    vesktop.enable = false;
    vesktop.colors.enable = false;
    nixcord.colors.enable = false;
  };

  # home manager specialisations are experimental,
  specialisation.day.configuration = {
    stylix.targets.vesktop.enable = false;
    stylix.targets.vesktop.colors.enable = false;
  };

  programs.playground.enable = true;

  programs.nixcord = {
    enable = true;
    discord.vencord.enable = true;
    vesktop.enable = true;

    config = {
      plugins = {
        ircColors.enable = true;
        showHiddenChannels.enable = true;
        spotifyCrack.enable = true;
        unindent.enable = true;
        youtubeAdblock.enable = true;
        fakeNitro.enable = true;
      };
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      "font" = "monospace normal 24";
      "incremental-search" = true;
    };
    mappings = {
      n = "scroll up";
      m = "scroll down";
      s = "scroll left";
      t = "scroll right";

      N = "scroll half-up";
      M = "scroll half-down";

      h = "search forward";
      H = "search backward";
      r = "reload";
    };
  };

  programs.waybar =
    let
      mc-player-count = pkgs.writeShellScriptBin "mc-player-count-wrapped" ''
        exec ${pkgs.mc-player-count}/bin/mc-player-count \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 1 /run/agenix/mc-server-address)" \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 2 /run/agenix/mc-server-address)"
      '';
      ha-text-widget = pkgs.writeShellScriptBin "ha-text-widget-wrapped" ''
        	    exec ${pkgs.text-widget}/bin/ha-text-widget \
                  "$(${pkgs.coreutils}/bin/cut -d ':' -f 1 /run/agenix/mc-server-address)" \
                  "$(${pkgs.coreutils}/bin/cut -d ':' -f 2 /run/agenix/mc-server-address)"
        		  
        	${pkgs.text-widget}/bin/ha-text-widget --server 192.168.1.43:1235 temp hum co2 pm25
        	  '';
    in
    {
      enable = true;
      settings = {
        mainBar = {
          height = 26;
          spacing = 13;
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "custom/break-enforcer"
          ];
          modules-center = [
            "clock#LA"
            "clock"
          ];
          modules-right =
            [ ]
            ++ (if true then [ "custom/minecraft-widget" ] else [ ])
            ++ (if true then [ "custom/ha-text-widget" ] else [ ])
            ++ [ "pulseaudio" ];

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
          };
          clock = {
            tooltip-format = "<big>{:%Y
				%B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          "clock#LA" = {
            timezone = "America/Los_Angeles";
            tooltip-format = "<big>{:%Y
				%B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          pulseaudio = {
            format = "{volume}%";
          };
          "custom/break-enforcer" = {
            exec = "${pkgs.break-enforcer}/bin/break-enforcer status --update-period 1s";
            format = "{}";
          };
          "custom/ha-text-widget" = {
            exec = "${pkgs.text-widget}/bin/ha-text-widget --server 192.168.1.43:1235 temp hum co2 pm25";
            format = "{}";
          };
          "custom/minecraft-widget" = {
            exec = "${mc-player-count}/bin/mc-player-count-wrapped";
            format = "{}";
          };
        };
      };
    };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      prefers_reduced_motion = true;
      enter_accept = true;
      inline_height = 0; # https://github.com/atuinsh/atuin/issues/2207
      filter_mode_shell_up_key_binding = "directory";
      style = "full";
      history_filter = [
        "^z"
      ];
    };
  };

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [ pkgs.passff-host ];
    policies."3rdparty".Extensions."leechblockng@proginosko.com" = {
      setName1 = "does_this_work";
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        engines = {
          "kagi" = {
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/asset/4f24904/kagi_assets/logos/yellow_3.svg";
            definedAliases = [ "@kagi" ];
          };

          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        force = true;
        default = "ddg";
        order = [
          "kagi"
          "ddg"
          "google"
        ];
      };
      settings = {
        extensions.autoDisableScopes = 0;
        browser.search.defaultenginename = "kagi";
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

  programs.alacritty = {
    enable = true;
  };

  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # file --mime-type -b
      "application/*.document" = "libreoffice.desktop";
      # wildcards like * do not work sadly :(
      "image/jpeg" = "qimgv.desktop";
      "text/html" = "firefox.desktop";
      "application/pdf" = "zathura.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.sessionVariables = {
    NIX_PATH = "nixpkgs=flake:nixpkgs";
    NIX_CONF_DIR = lib.mkDefault (config.home.homeDirectory + "/nix");
  };

  home.file = builtins.listToAttrs (
    map (
      path:
      let
        f = lib.strings.removePrefix (inputs.self + "/dotfiles/") (toString path);
      in
      {
        name = f;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink (
            config.home.sessionVariables.NIX_CONF_DIR + "/dotfiles/" + f
          );
        };
      }
    ) (lib.filesystem.listFilesRecursive ./dotfiles)
  ); # dotfiles dir is in the same directory this file

  # stylix may needd this
  # gtk.gtk4.theme = config.gtk.theme;

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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
