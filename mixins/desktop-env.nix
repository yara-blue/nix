{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    swaybg # wallpaper
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

    hyprpicker # color picker
    kooha # screen recording

    inputs.nixpkgs-wayland.packages.${system}.sway-unwrapped
    waybar
    # widgets
    text-widget

    kickoff
    kickoff-dot-desktop

    break-enforcer

    alsa-utils

    tuigreet
    switch-theme
    plymouth
    plymouth-blahaj-theme
  ];

  # environment.pathsToLink = [
  # 	"/share/applications"
  # 	"/share/xdg-desktop-portal"
  # ];

  services.break-enforcer = {
    enable = true;
    tcp-api = true;
    work-duration = "25m";
    break-duration = "5m";
    break-start-notify = [
      "audio"
      "command(${pkgs.procps}/bin/pkill --ignore-ancestors --full java.*minecraft)"
    ];
    break-end-notify = [ "audio" ];
    work-reset-notify = [ ];
  };
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${inputs.nixpkgs-wayland.packages.x86_64-linux.sway-unwrapped}/bin/sway";
        # command = "${pkgs.sway}/bin/sway";
        user = "yara";
      };
      default_session = initial_session;
    };
  };

  # stores secrets in pass password store
  services.passSecretService.enable = true;
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      		export MOZ_ENABLE_WAYLAND=1
      		export WLR_RENDERER=vulkan
      	'';
  };

  # for minecraft server plugin
  age.secrets.mc-server-address = {
    owner = "yara";
    group = "users";
    mode = "400";
    rekeyFile = ./. + "/../secrets/mc-server-address.age";
  };

  specialisation.day.configuration = {
    stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";
  };

  stylix = {
    enable = true;
    # anything from: https://tinted-theming.github.io/tinted-gallery/
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";

    targets.plymouth.enable = false;

    fonts = {
      sizes = {
        terminal = 20;
        applications = 12;
        desktop = 12;
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "FantasqueSansM Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  systemd.services.theme-switcher = {
    enable = true;
    description = "switch to dark mode at night, light mode during the day";
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      ExecStart = "${pkgs.switch-theme}/bin/switch-theme";
    };
    wantedBy = [ "multi-user.target" ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

}
