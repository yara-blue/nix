{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./zfs.nix # sets kernel and loads zfs module
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 30;
  boot.loader.timeout = 10; # seconds (screen can be slow to turn on)
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    # FIXME
    enable = true;
    theme = "blahaj";
    themePackages = with pkgs; [
      plymouth-blahaj-theme
    ];
  };

  boot = {
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/abydos-nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/abydos-boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  networking = {
    interfaces.enp9s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
    firewall.allowedUDPPorts = [ 9 ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/abydos-swap";
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.rtl-sdr.enable = true;
}
