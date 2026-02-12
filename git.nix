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
      #   key = "git@yara.blue";
      #   signByDefault = false;
      # };
    };

    direnv = {
      enable = true;
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
  };
}
