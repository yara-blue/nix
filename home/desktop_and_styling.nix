{
  config,
  pkgs,
  ...
}@inputs:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [ pkgs.passff-host ];
    policies."3rdparty".Extensions."leechblockng@proginosko.com" = {
      setName1 = "does_this_work";
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        engines = {
          "kagi" = {
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/asset/4f24904/kagi_assets/logos/yellow_3.svg";
            definedAliases = [ "@kagi" ];
          };

          "NixOs Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options?channel=unstable";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages?channel=unstable";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Home manger options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/?release=master";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@ho" ];
          };

        };
        force = true;
        default = "ddg";
        order = [
          "kagi"
          "ddg"
          "google"
        ];
      };
      settings = {
        extensions.autoDisableScopes = 0;
        browser.search.defaultenginename = "kagi";
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        # TODO request adguard here https://gitlab.com/rycee/nur-expressions/-/issues
        leechblock-ng
        passff
        vimium-c
      ];
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
