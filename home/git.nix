{ pkgs, config, ... }:
let
  diff-formatter = pkgs.writeShellApplication {
    name = "adaptive-diff-formatter";
    runtimeInputs = [
      pkgs.difftastic
      pkgs.gawk
      pkgs.coreutils
      pkgs.ncurses
    ];
    text = ''
      widest=$(
        difft --color never --tab-width 2 --display side-by-side "$1" "$2" |
          awk 'length > max { max = length } END { print max+0 }'
      )

      if [ "$widest" -gt "$(tput cols)" ]; then
        display=inline
      else
        display=side-by-side
      fi

      exec difft --color always --tab-width 2 --display "$display" "$1" "$2"
    '';
  };
in
{

  home.shell.enableFishIntegration = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "${config.programs.jujutsu.settings.user.name}";
      user.email = "${config.programs.jujutsu.settings.user.email}";
      rerere.enable = true;
      pull.rebase = true;
    };
    ignores = [
      ".direnv"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "git@yara.blue";
        name = "Yara";
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

      ui = {
        # overridden for pager (see below)
        paginate = "auto";
        # pager = "${pkgs.delta}/bin/delta";
        # for delta
        # diff-formatter = ":git";
        diff-formatter = [
          "${diff-formatter}/bin/adaptive-diff-formatter"
          "$left"
          "$right"
        ];
        # diff-formatter
        #       "${pkgs.difftastic}/bin/difft"
        #       "--color=always"
        #       "$left"
        #       "$right"
        #     ];

        default-command = [
          "log"
          "--reversed"
          "--no-pager"
        ];

        revsets.log = "@ | ancestors(tronk()..(visible_heads() & mine()), 2) | tronk()";
        # diff-editor = "${pkgs.meld}/bin/meld";
      };
    };
  };

  programs.mergiraf = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };
}
