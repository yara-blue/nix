{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		nil
		rust-analyzer
		cmake
		ninja
		pkg-config
	];
}
