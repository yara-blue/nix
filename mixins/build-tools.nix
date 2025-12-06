{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		gcc15
		clang_20
		gnumake
		cmake
		uv
		typst
	];
}
