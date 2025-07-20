{ secrets, ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/sda" ];
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      secrets.hosts.natvps.ipv4.ip
      secrets.hosts.natvps.ipv6.ip
    ];
    routes = [
      { Gateway = secrets.hosts.natvps.ipv4.gateway; }
      {
        Gateway = secrets.hosts.natvps.ipv6.gateway;
        GatewayOnLink = true;
      }
    ];
  };

}
