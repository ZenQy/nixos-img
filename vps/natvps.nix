{ secrets, ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/sda" ];
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      secrets.natvps.ipv4.ip
      secrets.natvps.ipv6.ip
    ];
    routes = [
      { Gateway = secrets.natvps.ipv4.gateway; }
      {
        Gateway = secrets.natvps.ipv6.gateway;
        GatewayOnLink = true;
      }
    ];
    DHCP = "no";
    networkConfig = {
      IPv6AcceptRA = "no";
      LinkLocalAddressing = "no";
    };
  };

}
