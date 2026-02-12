{
  inputs,
  config,
  pkgs,
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
    ./git.nix
    ./nfs.nix
    ./nvim.nix
    ./eza_theme.nix
  ];

  stylix.targets = {
    neovim.enable = false;
    alacritty.fonts.override = {
      size = 20;
    };
    firefox.profileNames = [ "default" ];
    waybar.opacity.override = {
      desktop = 0.5;
    };
  };

  programs.waybar =
    let
      wrapped = pkgs.writeShellScriptBin "mc-player-count-wrapped" ''
        exec ${pkgs.mc-player-count}/bin/mc-player-count \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 1 /run/agenix/mc-server-address)" \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 2 /run/agenix/mc-server-address)"
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
            exec = "${wrapped}/bin/mc-player-count-wrapped";
            format = "{}";
          };
        };
      };
    };

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
    nativeMessagingHosts = [ pkgs.passff-host ];
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        default = "ddg";
        order = [
          "ddg"
          "google"
        ];
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

  programs.alacritty = {
    enable = true;
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
