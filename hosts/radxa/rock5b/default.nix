{ ... }:

{
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3588-rock-5b.dtb";
    filter = "*rock-5b*.dtb";
  };

  systemd.network.networks.default = {
    name = "eth0";
    address = [
      "10.0.0.15/24"
    ];
    gateway = [
      "10.0.0.1"
    ];
    DHCP = "ipv6";
  };

}
