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
		pass
		gnupg
		neovim
		killall
		fish
		bash

		curl
		wget
		efibootmgr

		rmpc

		nix-output-monitor
	];
}
