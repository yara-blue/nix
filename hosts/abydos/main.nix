{ pkgs, config, self, inputs, hostname, ...}@args : {
	imports = [
		./hardware.nix
		./../../mixins/desktop-env.nix
		./../../mixins/build-tools.nix
		./../../mixins/cli-tools.nix
		./../../mixins/nfs.nix
		./../../mixins/vpn.nix
		./../../mixins/language-tools.nix
		./../../mixins/graphical/productivity.nix
		./../../mixins/graphical/common.nix
		./../../mixins/graphical/fun.nix
	];


  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

	# Enable the X11 windowing system.
	services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.openssh = {
	  enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yara = {
    isNormalUser = true;
    description = "Yara";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  fileSystems."/home/yara/Documents" = {
    device = "asgard:/home/yara/Documents";
    fsType = "nfs4";
  };
  fileSystems."/home/yara/Prive" = {
    device = "asgard:/home/yara/prive";
    fsType = "nfs4";
  };
  fileSystems."/home/yara/Videos/Series" = {
    device = "asgard:/srv/videos/series";
    fsType = "nfs4";
  };
  fileSystems."/home/yara/Share" = {
    device = "asgard:/srv/share";
    fsType = "nfs4";
  };
  fileSystems."/home/yara/Photos" = {
    device = "asgard:/srv/photos";
    fsType = "nfs4";
  };

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

