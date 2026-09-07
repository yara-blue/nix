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
    ./home/firefox.nix
    ./home/desktop_and_styling.nix
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

  programs.fish = {
    preferAbbrs = true;
    shellAbbrs.jd = {
      expansion = "jj describe -m \"%\"";
      setCursor = true;
    };
    shellAbbrs.jdr = {
      expansion = "jj describe -r % -m \"\"";
      setCursor = true;
    };
    interactiveShellInit = ''
      	    set -g fish_greeting (todo list --startable | shuf -n 1)
      		if test -n "$task"
      			echo $task
      		end
      	  '';
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
