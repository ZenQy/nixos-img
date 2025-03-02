{ secrets, ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/vda" ];
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      secrets.legend.ipv4.ip
      secrets.legend.ipv6.ip
    ];
    routes = [
      { Gateway = secrets.legend.ipv4.gateway; }
      {
        Gateway = secrets.legend.ipv6.gateway;
        GatewayOnLink = true;
      }
    ];
  };

}
