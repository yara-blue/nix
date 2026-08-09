{ pkgs, ... }:
{

  home.shell.enableFishIntegration = true;

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

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
		# format = "ssh";
		# TODO add private key to agenix (now in .ssh on the work system)
		# https://developers.yubico.com/SSH/Securing_git_with_SSH_and_FIDO2.html
		# key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOcnSx0wDTKZr4i4YZXosm+zgMsRZfFhmHEtgBpTwIIZAAAABHNzaDo= Git signing key git@yara.blue";
        # signByDefault = true;
      # };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      shellInit = "fish_vi_key_bindings";
      plugins =
        with pkgs.fishPlugins;
        let
          mkPlugin = p: {
            inherit (p) src;
            name = "${p.pname}";
          };
        in
        (map mkPlugin [
          puffer # (!! !$ ..+ etc)
          done # notify when long running command done
          fish-you-should-use
          colored-man-pages
          autopair # try pisces?
          # sponge   # remove failed commands from history
        ]);
    };
    jujutsu = {
      enable = true;
      settings.user = {
        email = "git@yara.blue";
        name = "Yara";
        behavior = "own";
        backend = "ssh";
		key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOcnSx0wDTKZr4i4YZXosm+zgMsRZfFhmHEtgBpTwIIZAAAABHNzaDo= Git signing key git@yara.blue";

        ui = {
          paginate = "never";
          # pager = "${pkgs.delta}/bin/delta";
          # for delta
          # diff-formatter = ":git";
          diff-formatter = [
            "${pkgs.difftastic}/bin/difft"
            "--color=always"
            "$left"
            "$right"
          ];

          default-command = [
            "log"
            "--reversed"
            "--no-pager"
          ];
          merge-editor = [
            "${pkgs.meld}/bin/meld"
            "$left"
            "$base"
            "$right"
            "-o"
            "$output"
            "--auto-merge"
          ];

          revsets.log = "@ | ancestors(tronk()..(visible_heads() & mine()), 2) | tronk()";
          # diff-editor = "${pkgs.meld}/bin/meld";
        };

        git = {
          private-commits = "description(glob:'wip:*') | description(glob:'trial:*')";
          write-change-id-header = true;

          fetch = [
            "upstream"
            "origin"
          ];
          push = "origin";
          auto-local-bookmark = true;
        };
      };
    };
    mergiraf = {
		enable = true;
		enableGitIntegration = true;
		enableJujutsuIntegration = true;
	};
  };
}
