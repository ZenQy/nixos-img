{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./disko.nix
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    loader.generic-extlinux-compatible.configurationLimit = 2;
    initrd.availableKernelModules = [
      "nvme"
      "usb_storage"
      "sd_mod"
      "mmc_block"
    ];
    kernelParams = [
      "earlycon"
      "console=serial"
      "console=ttyS0,1500000"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  disko.imageBuilder.extraPostVM =
    let
      imageName = "${config.disko.devices.disk.main.imageName}.${config.disko.imageBuilder.imageFormat}";
      path = ./. + "/${config.networking.hostName}/u-boot";
    in
    lib.mkBefore ''
      ${pkgs.coreutils}/bin/dd if=${path}/idbloader.img of=$out/${imageName} seek=64 conv=fsync,notrunc
      ${pkgs.coreutils}/bin/dd if=${path}/u-boot.itb of=$out/${imageName} seek=16384 conv=fsync,notrunc
      # ${pkgs.parted}/bin/parted $out/${imageName} set 1 legacy_boot on
    '';

}
