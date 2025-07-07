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
          with builtins;
          let
            imageName = "${hostname}.raw";
            path = ./. + "/${hostname}/u-boot";
            info = import path;
            files = attrNames info;
            cmd = map (
              file:
              " ${pkgs.coreutils}/bin/dd if=${path}/${file} of=$out/${imageName} seek=${toString info.${file}} conv=fsync,notrunc"
            ) files;
          in
          lib.mkAfter (concatStringsSep "\n" cmd);
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
