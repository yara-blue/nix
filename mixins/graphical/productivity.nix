{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		zed-editor # cant log in
		inputs.tracy.packages.${pkgs.system}.default

		anki
		# broken see build effort in anki-widget/flake checkout on	#Work
		# anki-widget 
	
		audacity
		vlc
		nautilus

		# TODO move somewhere else?
		yubikey-manager
		cryptsetup
	];
}
