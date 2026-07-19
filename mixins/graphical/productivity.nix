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
    inputs.tracy.packages.${pkgs.system}.default
    easyeffects
    inkscape

    libreoffice

    sqlitebrowser
    gnome-disk-utility
    gparted

    anki
    # broken see build effort in anki-widget/flake checkout on	#Work
    # anki-widget

    qbittorrent

    audacity
    vipsdisp
    vlc
    nautilus

    # TODO move somewhere else?
    yubikey-manager
    cryptsetup

	# GUI for routing pipewire nodes
	crosspipe
  ];

  programs.localsend.enable = true;
}
