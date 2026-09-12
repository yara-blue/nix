{ pkgs, config, ... }:
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
    # signing = { #soon tm
    # format = "ssh";
    # TODO add private key to agenix (now in .ssh on the work system)
    # https://developers.yubico.com/SSH/Securing_git_with_SSH_and_FIDO2.html
    # key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOcnSx0wDTKZr4i4YZXosm+zgMsRZfFhmHEtgBpTwIIZAAAABHNzaDo= Git signing key git@yara.blue";
    # signByDefault = true;
    # };
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
      # signing = {
      #   behavior = "own";
      #   backend = "ssh";
      #   key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOcnSx0wDTKZr4i4YZXosm+zgMsRZfFhmHEtgBpTwIIZAAAABHNzaDo= Git signing key git@yara.blue";
      # };

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
