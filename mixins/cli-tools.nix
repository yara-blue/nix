{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		zoxide
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

		# home automation
		text-widget 
		ui

		nix-output-monitor
	];

	services.pcscd.enable = true;
	programs.gnupg.agent = {
		enable = true;
		# pinentryPackage = pkgs.pinentry-tty;
	};
}
