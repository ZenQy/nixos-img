{ ... }:

{

  systemd.network.networks.default = {
    name = "eth0";
    networkConfig = {
      Address = "10.0.0.12/24";
      Gateway = "10.0.0.1";
      DHCP = "ipv6";
    };
  };

}
