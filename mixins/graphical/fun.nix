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
    kodi
    freetube
    telegram-desktop
    signal-desktop

    # gaming
    prismlauncher

    # software defined radio
    gqrx
    rtl-sdr
  ];

  programs.steam = {
    enable = true;
	protontricks.enable = true;
  };
  programs.gamemode.enable = true;
}
