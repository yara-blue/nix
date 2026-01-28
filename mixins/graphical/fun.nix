{ pkgs, lib, inputs, config, myOverlays, ... }: {
	environment.systemPackages = with pkgs; [
		kodi
		freetube
		telegram-desktop

		# gaming
		steam
		prismlauncher
		
		# software defined radio
		gqrx
		rtl-sdr
	];
}
