{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.sway;
in
{
  options = {
    sway = {
      enable = lib.mkEnableOption "SWAY";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        		export MOZ_ENABLE_WAYLAND=1
        		export WLR_RENDERER=vulkan
        	'';
    };
  };
}
