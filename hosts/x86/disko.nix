{ config, ... }:

{
  disko.devices = {
    disk.main = {
      imageName = config.networking.hostName;
      imageSize = "1200M";
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
                    }
                    // (
                      if x == "/swap" then
                        {
                          swap.swapfile.size = "100M";
                        }
                      else
                        {
                          mountOptions = [
                            "compress-force=zstd"
                            "nosuid"
                            "nodev"
                          ];
                        }
                    );
                  })
                  [
                    "/boot"
                    "/home"
                    "/nix"
                    "/var"
                    "/swap"
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
