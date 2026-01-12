{ config, ... }:

{
  disko.devices = {
    disk.main = {
      imageName = config.networking.hostName;
      imageSize = "1500M";
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {

          biso = {
            size = "1M";
            type = "EF02"; # for grub MBR
            priority = 0;
          };

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
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = builtins.listToAttrs (
                map
                  (x: {
                    name = x;
                    value = {
                      mountpoint = x;
                      mountOptions = [
                        "compress-force=zstd"
                        "nosuid"
                        "nodev"
                      ];
                    };
                  })
                  [
                    "/boot"
                    "/nix"
                    "/var"
                  ]
              );
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "relatime"
        "mode=755"
        "nosuid"
        "nodev"
      ];
    };
  };
}
