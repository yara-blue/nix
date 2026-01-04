{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		# lsps
		nixd # nix language server
		rust-analyzer
		typos-lsp
		tinymist # typst language service
		lua51Packages.lua-lsp # neovim targets lua 5.1
		vale-ls # prose checker
		codebook # spell checker
	];
}
