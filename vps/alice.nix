{ secrets, ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/vda" ];
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      secrets.alice.ipv6.ip
    ];
    routes = [
      {
        Gateway = secrets.alice.ipv6.gateway;
        GatewayOnLink = true;
      }
    ];
  };

}
