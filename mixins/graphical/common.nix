{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		discord
		firefox

		alacritty
		alacritty-theme
		swappy # clipboard screenshot editor

		nautilus
	];
}
