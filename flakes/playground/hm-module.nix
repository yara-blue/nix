self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cd-playground = self.packages.${pkgs.system}.cd-playground;
  playground = self.packages.${pkgs.system}.default;
in
{
  options.programs.playground = {
    enable = lib.mkEnableOption "playground";
  };

  config = lib.mkIf config.programs.playground.enable {
    home.packages = [
      playground
      cd-playground
    ];

    programs.bash.initExtra = ''
      cdp() {
        cd "$(${cd-playground}/bin/cd-playground)"
      }
      playground() {
        path="$(${playground}/bin/playground)"
        cd "$path"
        $EDITOR "$path"
      }
    '';
    programs.fish.shellInit = ''
      function cdp
        cd (${cd-playground}/bin/cd-playground)
      end
      function playground
        path="$(${playground}/bin/playground)"
        cd "$path"
        $EDITOR src/main.rs
      end
    '';
  };
}
