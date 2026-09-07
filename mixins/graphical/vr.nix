{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  ...
}:
{
  services.monado = {
    enable = true;
    highPriority = true;
    forceDefaultRuntime = true;
  };

  environment.systemPackages = with pkgs; [
    xrizer # replaces opencomposite which is deprecated
    monado-vulkan-layers
    openvr
    opencomposite
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb",    ATTRS{idVendor}=="045e", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="045e", TAG+="uaccess"
  '';

  hardware.graphics.extraPackages = [ pkgs.monado-vulkan-layers ];
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-rtsp-bin ];

  systemd.user.sockets.monado.wantedBy = lib.mkForce [ ];

  environment.sessionVariables.PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";

  systemd.user.services.monado.environment = {

    # AMD: don't use the NVIDIA-specific display/compositor overrides
    XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";

    XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";
    U_PACING_COMP_TIME_FRACTION_PRECENT = "90";
    DISPLAY = ":0";

    # 4320x2160@60.00
    # Full refresh rate causes some issues rn
    XRT_COMPOSITOR_DESIRED_MODE = "2";

    WMR_HANDTRACKING = "0";

    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";

    VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
  };

  # # package is broken
  # programs.envision = {
  #   enable = true;
  #   openFirewall = true;
  # };
}
