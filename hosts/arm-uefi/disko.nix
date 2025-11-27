{ config, ... }:

{
  disko.devices.disk.main = {
    imageName = config.networking.hostName;
    imageSize = "1500M";
    device = "/dev/vda";
    type = "disk";

    content = {
      type = "gpt";

      partitions = {

        boot = {
          type = "EF00";
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
}
