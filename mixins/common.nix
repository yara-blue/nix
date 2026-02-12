{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  home-manager,
  ...
}:
{

  users.users.yara.isNormalUser = true;
  users.defaultUserShell = pkgs.fish;

  programs = {
    fish.enable = true;
  };

  environment.localBinInPath = true;
  environment.shellAliases = {
    # Git abbreviations
    "gau" = "git add --update";
    "ga" = "git add";
    "gcmsg" = "git commit -am";
    "gcob" = "git checkout -b";
    "gd" = "git diff";
    "gst" = "git status";
    "gp" = "git push";
    "gpf" = "git push --force-with-lease";

    # other
    "v" = "nvim";
    "m" = "neomutt";

    "tt" = "trash put";
    "ctrlc" = "wl-copy";
    "ctrlv" = "wl-paste";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    libertine
	nerd-fonts.open-dyslexic
	nerd-fonts.im-writing
	nerd-fonts.fira-code
	nerd-fonts.caskaydia-mono
	nerd-fonts.fantasque-sans-mono
  ];

  # enable usb automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  networking.extraHosts = ''
    	192.168.1.43 sgc
    	192.168.1.15 asgard
  '';

  nixpkgs = {
    overlays = myOverlays;
    config.allowUnfree = true;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
    "yara"
  ];

  # secrets management
  age = {
    identityPaths = [ "/home/yara/.ssh/yara_agenix_ed25519" ]; # TODO relative?
  };

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # Key for the user that needs to decrypt?
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzIRtes7reuVAAUZnRj5O3ti+aSURofgbS4DbTkmVvU yara@abydos";

    masterIdentities = [
      /home/yara/nix/age-yubikey-identity-1b1c41c4.pub # TODO path
      /home/yara/nix/age-yubikey-identity-3035da2f.pub # TODO path
    ];
    storageMode = "local";
    localStorageDir = ./. + "/../secrets/rekeyed/${config.networking.hostName}";
  };

  # users.users.root.hashedPasswordFile = config.age.secrets.root-pw-hash.path;
}
