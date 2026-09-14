{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib.asserts;
with lib;
let
  rustIcon = pkgs.fetchurl {
    url = "https://www.rust-lang.org/logos/rust-logo-512x512.png";
    hash = "sha256-OMCHM0RNhnO2bh6eZ0ILRi3Q5VZ76hjYTaexHRyM8Rg=";
  };
  rust_api_search =
    { channel, library }:
    let
      prefix =
        if channel == "nightly" then
          "n"
        else if channel == "beta" then
          "b"
        else
          "";
    in
    {
      "Rust search ${channel} ${library} API" = {
        urls = [
          {
            template = "https://doc.rust-lang.org/${channel}/${library}/index.html";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = rustIcon;
        definedAliases = [ "@${prefix}${library}" ];
      };
    };
  combinations = builtins.concatLists (
    map
      (
        channel:
        map
          (library: {
            channel = channel;
            library = library;
          })
          [
            "std"
            "core"
            "alloc"
          ]
      )
      [
        "stable"
        "nightly"
        "beta"
      ]
  );
  rust_search_engines = mergeAttrsList (map rust_api_search combinations);
in
{
  programs.firefox = {
    enable = true;
    # fixefox must be unwrapped to be configured by home manager. This
    # usus the nix function wrapFirefox to wap a unwrapped firefox post
    # configuration?
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      nativeMessagingHosts = [
        pkgs.passff-host
      ];
      extraPolicies = {
        AppAutoUpdate = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        UserMessaging = {
          WhatsNew = true;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          SponsoredStories = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
      };
    };

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
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@ho" ];
          };
        }
        // rust_search_engines;
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

}
