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
            ${pkgs.gzip}/bin/gzip $out/${imageName}
          '';
      };

      devices.disk.main = {
        imageName = hostname;
        imageSize = "3000M";
        # 磁盘路径。Disko 生成磁盘镜像时，实际上是启动一个 QEMU 虚拟机走一遍安装流程。
        # 因此无论你的 VPS 上的硬盘识别成 sda 还是 vda，这里都以 Disko 的虚拟机为准，指定 vda。
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
