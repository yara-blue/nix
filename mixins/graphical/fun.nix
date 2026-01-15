{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		kodi
		freetube
		steam
		telegram-desktop
		
		# software defined radio
		gqrx
		rtl-sdr
	];
}
