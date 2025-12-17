{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		zoxide
		direnv
		git
		eza
		bat
		htop
		btop
		ripgrep
		neomutt
		fd
		hyperfine
		tokei

		pass
		gnupg
		pinentry-tty

		strace
		nmap
		samply

		neovim
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

		# home automation
		text-widget
		ui

		trashy

		git-undeadname

		nix-output-monitor
		comma
	];

	services.pcscd.enable = true;
	programs.gnupg.agent = {
		enable = true;
		# pinentryPackage = pkgs.pinentry-tty;
	};
}
