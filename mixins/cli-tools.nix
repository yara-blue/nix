{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		zoxide
		direnv
		git
		eza
		bat
		usbutils
		htop
		btop
		dua 			# disk usage
		ripgrep
		ast-grep
		neomutt
		fd
		hyperfine
		tokei

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
		websocat # used for typst preview from neovim
		neomutt

		killall
		fish
		zsh
		bash

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

		git-undeadname

		nix-output-monitor
		comma
	];

    # Yubikey
	services.pcscd.enable = true;
	# Yubikey and also software defined radio
    services.udev.packages = [ pkgs.yubikey-personalization pkgs.rtl-sdr pkgs.gqrx ];

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		# pinentryPackage = pkgs.pinentry-tty;
	};

	# use gpg as ssh agent
	programs.ssh.startAgent = false;
	environment.shellInit = ''
	    gpg-connect-agent /bye
    	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
	'';

}
