{ secrets, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      secrets.hosts.sailor.ipv4.ip
      secrets.hosts.sailor.ipv6.ip
    ];
    routes = [
      { Gateway = secrets.sailor.hosts.ipv4.gateway; }
      {
        Gateway = secrets.sailor.hosts.ipv6.gateway;
        GatewayOnLink = true;
      }
    ];
  };

}
