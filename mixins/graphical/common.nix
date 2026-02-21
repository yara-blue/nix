{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  ...
}:
{
  environment.systemPackages = with pkgs; [
	vencord
    fluffychat
    firefox
    pavucontrol

	# picture editing
	gimp
	qimgv
	darktable

	# document viewing
	foliate # ebook viewer (supports pdf as well)

    alacritty
    alacritty-theme
    swappy # clipboard screenshot editor

    nautilus
  ];
}
