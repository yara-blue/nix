{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		gcc15
		clang_20
		gnumake
		cmake
		ninja
		pkg-config
		uv
		cargo # we generally add flakes to projects and use the cargo from
		      # there, however we need to have cargo for RA to work in rustc

		typst

		texliveFull
	];
}
