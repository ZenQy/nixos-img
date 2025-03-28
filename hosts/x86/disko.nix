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
          size = "1M";
          type = "EF02"; # for grub MBR
          priority = 0;
        };

        # 交换区
        swap = {
          size = "500M";
          content = {
            type = "swap";
          };
          priority = 1;
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
