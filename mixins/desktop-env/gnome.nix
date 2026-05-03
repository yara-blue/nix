{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gnome;
in
{
  options = {
    gnome = {
      enable = lib.mkEnableOption "GNOME";
    };
  };

  config = lib.mkIf cfg.enable {
    # todo: when upgrading to 25.11, replace
    # https://wiki.nixos.org/wiki/GNOME
    services.desktopManager.gnome.enable = true;
    services.power-profiles-daemon.enable = lib.mkForce false;

    # To disable installing GNOME's suite of applications
    # and only be left with GNOME shell.
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
	# no gnome apps at all pls
    environment.gnome.excludePackages = with pkgs; [
      baobab
      decibels
      epiphany
      gnome-text-editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      loupe
      nautilus
      papers
      gnome-connections
      showtime
      simple-scan
      snapshot
      yelp
    ];
  };
}
