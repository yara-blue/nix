{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.types;
let
  cfg = config.services.go-to-bed;
in
{
  options = {
    services.startup-sound = {
      enable = mkEnableOption "startup-sound";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.startup-sound = {
      description = "Play a sound when the system boots";
      wantedBy = [ "multi-user.target" ];
      after = [ "sound.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.startup-sound}/bin/startup-sound";
      };
    };
    systemd.services.store-pipewire-default-out-hw = {
      description = "Store the pipewire default output hardware in /var/cache/";
      before = [ "shutdown.target" ];
      conflicts = [ "shutdown.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.store-pipewire-out}/bin/store-pipewire-out";
      };
    };
  };
}
