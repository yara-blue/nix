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
	  identityPaths = [ "/home/yara/.ssh/yara.pub" ]; # TODO relative?
  	  # secrets.root-pw-hash.rekeyFile = ./../secrets/root-pw-hash.age;
  };

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
	# Right now this is just the main system. Need to move/override this in 
	# host specific files. Maybe pass it in?
	hostPubkey = "ssh-rsa
	AAAAB3NzaC1yc2EAAAADAQABAAACAQDQ2iTmgsUTJhhs8b8FCSYCiA8IEnIl7rUvOjQN9tJD0S8j4zFCl4t6osrIEP2RWOqk5e5eqK1CCMx7WBhHBQEGclxuTr3aATm145y3/1p4CSOhdciW7SQNgvVnkrkTW6OoZhfNiJZDPddolEb0TKC5bAijvJeWifTu0755os+N3jEAqdEzIcZKne6QtaX3yrkxmIVKny04wTbgpb9do3RHNoCYkFqvtwlc0Grc9pTK4M1ZAOT0ZslhuXJLJOaFQOES6d9vLdGd3wxqCNBPfFMZdXJCuzh6GEILV7RoLOda6D//SEK3eudgHdG5JcwaEhtbsHQUpl1VTtlT7CxBsj3Nv7s/rWv9Zb/ZtSuJsEz1FlEZf6bl+v4VlcPu80Q7VCHby0WiMv582lIX7VBIASMfObrEH07v+yeVz7iid7BBOPD62ijEd9txWB5cBHoXuswDGZbTifQSi75hxz5metwSGGIKj3zHz0M2JHynEsOqcuBDWXMevySYMi5MTMvLG1euRjDABO53Y9o6B5myEFokYsNShromLnxD49AZrDeZfXEfKI2uy16UKhblkldHdpkfVAvITyDpivrRzGhN0xYMjJ8sVz0XT/+TOqgMIzfUCmXewEo2VX2Z/lNkmeaM5HrTpd4PcyK5sB8oS1VDHNrT0FjviRB7X0wp4sACYBSj0w==";

	masterIdentities = [ 
		./age-yubikey-identity-1b1c41c4.pub 
		./age-yubikey-identity-3035da2f.pub 
	];
	storageMode = "local";
	localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
  };

  # users.users.root.hashedPasswordFile = config.age.secrets.root-pw-hash.path;
}
