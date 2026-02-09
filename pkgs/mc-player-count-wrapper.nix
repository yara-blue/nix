{ pkgs }:

pkgs.writeShellScriptBin "mc-player-count-wrapped" ''
  exec ${pkgs.mc-player-count}/bin/mc-player-count \
  	"$(cat /run/agenix/mc-server-address | cut -d ':' -f 1)" \
  	"$(cat /run/agenix/mc-server-address | cut -d ':' -f 2)"
''
