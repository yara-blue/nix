{
  pkgs,
  ...
}:
{
  programs.waybar =
    let
      mc-player-count = pkgs.writeShellScriptBin "mc-player-count-wrapped" ''
        exec ${pkgs.mc-player-count}/bin/mc-player-count \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 1 /run/agenix/mc-server-address)" \
          "$(${pkgs.coreutils}/bin/cut -d ':' -f 2 /run/agenix/mc-server-address)"
      '';
      ha-text-widget = pkgs.writeShellScriptBin "ha-text-widget-wrapped" ''
        	    exec ${pkgs.text-widget}/bin/ha-text-widget \
                  "$(${pkgs.coreutils}/bin/cut -d ':' -f 1 /run/agenix/mc-server-address)" \
                  "$(${pkgs.coreutils}/bin/cut -d ':' -f 2 /run/agenix/mc-server-address)"
        		  
        	${pkgs.text-widget}/bin/ha-text-widget --server 192.168.1.43:1235 temp hum co2 pm25
        	  '';
    in
    {
      enable = true;
      settings = {
        mainBar = {
          height = 26;
          spacing = 13;
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "custom/break-enforcer"
          ];
          modules-center = [
            "clock#LA"
            "clock"
          ];
          modules-right =
            [ ]
            ++ (if true then [ "custom/minecraft-widget" ] else [ ])
            ++ (if true then [ "custom/ha-text-widget" ] else [ ])
            ++ [ "pulseaudio" ];

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
          };
          clock = {
            tooltip-format = "<big>{:%Y
				%B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          "clock#LA" = {
            timezone = "America/Los_Angeles";
            tooltip-format = "<big>{:%Y
				%B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          pulseaudio = {
            format = "{volume}%";
          };
          "custom/break-enforcer" = {
            exec = "${pkgs.break-enforcer}/bin/break-enforcer status --update-period 1s";
            format = "{}";
          };
          "custom/ha-text-widget" = {
            exec = "${pkgs.text-widget}/bin/ha-text-widget --server 192.168.1.43:1235 temp hum co2 pm25";
            format = "{}";
          };
          "custom/minecraft-widget" = {
            exec = "${mc-player-count}/bin/mc-player-count-wrapped";
            format = "{}";
          };
        };
      };
    };

  services.gammastep.settings = {
    enable = true;
    provider = "manual";
    latitude = "52.1326";
    longitude = "5.2913";
    temperature = {
      day = 6500;
      night = 3500;
    };
  };

  home.pointerCursor.enable = true;

  stylix.cursor.package = pkgs.rose-pine-cursor;
  stylix.cursor.name = "BreezeX-RosePineDawn-Linux"; # dark: BreezeX-RosePine-Linux
  stylix.cursor.size = 24;
  stylix.targets = {
    # native neovim themes better (highlight groups & more shades)
    neovim.enable = false;
    alacritty.fonts.override = {
      size = 20; # I like it big
    };
    firefox.profileNames = [ "default" ];
    waybar.opacity.override = {
      desktop = 0.5;
    };
    # todo fix theming for light themes
    # https://github.com/nix-community/stylix/pull/365/changes
    nixcord.enable = false;
    vesktop.enable = false;
    vesktop.colors.enable = false;
    nixcord.colors.enable = false;
  };
}
