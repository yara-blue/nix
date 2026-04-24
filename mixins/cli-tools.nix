{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    zoxide
    direnv
    git
	gh # official command line interface to github :(
    eza
    bat
	hexyl # hex editor
    usbutils
    htop
    btop
    dua # disk usage analyzer (use with -i)
    ripgrep
    ast-grep
    neomutt
	abook
    fd
    hyperfine
    tokei
    watchexec
	file

    pass
    gnupg
    pinentry-tty
    yubikey-personalization
    age-plugin-yubikey
    agenix-rekey

    strace
    nmap
    samply

    neovim
	helix
    websocat # used for typst preview from neovim
    neomutt
    md-to-pdf

    killall
	procps # pkill etc
    fish
    zsh
    bash
	starship
	starship-jj

    bind # contains nslookup, host, dig etc
    curl
    wget
    efibootmgr

    rmpc
    mpc

    numbat

    # home automation
    text-widget
    ui
    mc-player-count

    trashy

	# download & control cameras
	gphoto2

    git-undeadname

    nix-output-monitor
    comma

	# comics
	comic-mandown
	kcc # convert for epaper displays
  ];

  # Yubikey
  services.pcscd.enable = true;
  # Yubikey and also software defined radio
  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.rtl-sdr
    pkgs.gqrx
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryPackage = pkgs.pinentry-tty;
  };

  imports = [
  	./prompt.nix
  ];

  # use gpg as ssh agent
  programs.ssh.startAgent = false;
  environment.shellInit = ''
    	    gpg-connect-agent /bye
        	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    	'';

}
