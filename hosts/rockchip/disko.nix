{
  config,
  pkgs,
  lib,
  ...
}:

{

  disko =
    with builtins;
    let
      hostname = config.networking.hostName;
      imgName = "${hostname}.raw";
      dir = ./. + "/${hostname}/u-boot";
      meta = import dir;
      cmd = map (
        file:
        " ${pkgs.coreutils}/bin/dd if=${dir}/${file} of=$out/${imgName} seek=${toString meta.files.${file}} conv=fsync,notrunc"
      ) (attrNames meta.files);
    in
    {
      imageBuilder = {
        kernelPackages = pkgs.linuxPackages;
        extraPostVM = lib.mkAfter (concatStringsSep "\n" cmd);
      };

      devices = {
        disk.main = {
          imageName = hostname;
          imageSize = "1500M";
          device = "/dev/vda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {

              boot = {
                inherit (meta.boot) start size;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              root = {
                inherit (meta.root) start;
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
    };
}
