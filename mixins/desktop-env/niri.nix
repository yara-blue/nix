{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.niri;
in
{
  options = {
    niri = {
      enable = lib.mkEnableOption "niri";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      gdm.sessionPackages = [ pkgs.niri ];
      programs.dconf.enable = true;
    })
  ];
}
