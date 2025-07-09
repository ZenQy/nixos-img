{ ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/sda" ];
  };

  systemd.network.networks.default = {
    name = "eth0";
    networkConfig.DHCP = true;
  };

}
