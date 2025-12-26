{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		nixd # nix languge server
		rust-analyzer
		cmake
		ninja
		pkg-config
		tinymist # typst language service
		lua51Packages.lua-lsp # neovim targets lua 5.1
	];
}
