{ ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  systemd.network.networks.default = {
    name = "eth0";
    networkConfig.DHCP = true;
  };

}
