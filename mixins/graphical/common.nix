{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		discord
		fluffychat
		firefox

		alacritty
		alacritty-theme
		swappy # clipboard screenshot editor

		nautilus
	];
}
