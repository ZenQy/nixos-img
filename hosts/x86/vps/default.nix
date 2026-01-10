{ ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  systemd.network.networks.default = {
    name = "eth0";

    address = [
      "10.0.0.1/24"
    ];
    routes = [
      {
        Gateway = "10.0.0.1";
        GatewayOnLink = true;
      }
    ];

  };

}
