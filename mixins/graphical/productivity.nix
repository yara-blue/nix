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
    zed-editor # cant log in
    inputs.tracy.packages.${pkgs.system}.default
    easyeffects
    inkscape
    # inputs.zed.packages.${pkgs.system}.default

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
