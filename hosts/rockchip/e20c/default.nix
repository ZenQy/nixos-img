{ pkgs, ... }:

{
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3528-radxa-e20c.dtb";
    filter = "*e20c*.dtb";
  };

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../../pkgs/linux-flippy { });

  systemd.network.networks = {
    eth0 = {
      name = "eth0";
      networkConfig = {
        Address = "10.0.0.10/24";
        Gateway = "10.0.0.1";
        DHCP = "ipv6";
      };
    };
    eth1 = {
      name = "eth1";
      networkConfig = {
        Address = "10.0.0.20/24";
        Gateway = "10.0.0.1";
        DHCP = "ipv6";
      };
    };
  };

}
