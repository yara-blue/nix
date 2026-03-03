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
    services.go-to-bed = {
      enable = mkEnableOption "go-to-bed";
      time = mkOption {
        type = types.str;
        description = "At what time the system should turn off";
        default = "01:30";
      };
      play-sound = mkEnableOption "play-sound";
      notification = mkEnableOption "notifications";
    };
  };

  config = mkIf cfg.enable {
    # for notify-send to work from root
    services.systembus-notify.enable = lib.mkDefault true;

    systemd.services.go-to-bed = {
      description = "turn of the machine as a strong suggestion to go eepy";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.go-to-bed}/bin/go-to-bed \
            ${optionalString cfg.play-sound "--play-sound"} \
            ${optionalString cfg.notification "--notification"}
        '';
      };
    };
    systemd.timers.go-to-bed = {
      wantedBy = [ "timers.target" ];
      partOf = [ "go-to-bed.service" ];
      timerConfig = {
        OnCalendar = "${cfg.time}:00";
        Unit = "go-to-bed.service";
      };
    };
  };
}
