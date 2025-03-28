{
  config,
  pkgs,
  lib,
  ...
}:

{

  disko =
    let
      hostname = config.networking.hostName;
    in
    {
      imageBuilder = {
        kernelPackages = pkgs.linuxPackages;
        extraPostVM =
          let
            imageName = "${hostname}.raw";
            path = ./. + "/${hostname}/u-boot";
          in
          lib.mkAfter ''
            ${pkgs.coreutils}/bin/dd if=${path}/idbloader.img of=$out/${imageName} seek=64 conv=fsync,notrunc
            ${pkgs.coreutils}/bin/dd if=${path}/u-boot.itb of=$out/${imageName} seek=16384 conv=fsync,notrunc
          '';
      };

      devices.disk.main = {
        imageName = hostname;
        imageSize = "3000M";
        device = "/dev/vda";
        type = "disk";

        content = {
          type = "gpt";

          partitions = {

            boot = {
              start = "16MiB";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
                mountOptions = [
                  "compress-force=zstd"
                  "nosuid"
                  "nodev"
                ];
              };
            };

          };
        };
      };
    };
}
