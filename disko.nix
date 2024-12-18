{ ... }:

{
  disko.devices.disk.main = {
    imageSize = "1500M";
    # 磁盘路径。Disko 生成磁盘镜像时，实际上是启动一个 QEMU 虚拟机走一遍安装流程。
    # 因此无论你的 VPS 上的硬盘识别成 sda 还是 vda，这里都以 Disko 的虚拟机为准，指定 vda。
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