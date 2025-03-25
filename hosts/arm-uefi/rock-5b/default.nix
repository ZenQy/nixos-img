{ ... }:

{

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      "10.0.0.15/24"
    ];
    gateway = [
      "10.0.0.11"
    ];
    DHCP = "ipv6";
  };

}
