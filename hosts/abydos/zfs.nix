{
  lib,
  pkgs,
  config,
  ...
}:

let
  isUnstable = config.boot.zfs.package == pkgs.zfs_unstable or pkgs.zfsUnstable;
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (
      let
        zfsPackage =
          if isUnstable then
            kernelPackages.zfs_unstable
          else
            kernelPackages.${pkgs.zfs.kernelModuleAttribute};
      in
      !(zfsPackage.meta.broken or false)
    )
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  # Note this might jump back and worth as kernel get added or removed.
  boot.kernelPackages = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.zfs) latestKernelPackage;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "507c8f16";
  # boot.zfs.devNodes = "/dev/disk/by-partuuid/5af56b00-3251-471c-a512-bf0bdebbccea";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  systemd.services.zfs-mount.enable = false;
  fileSystems."/home/yara/Projects" = {
    device = "home/Projects";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };  
  fileSystems."/home/yara/tmp" = {
    device = "home/tmp";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };  
}
