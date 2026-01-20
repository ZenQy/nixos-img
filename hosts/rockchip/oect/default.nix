{ pkgs, ... }:

{
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3566-wxy-oec-turbo-4g.dtb";
    filter = "*oec*.dtb";
  };

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../../pkgs/linux-flippy { });

  systemd.network.networks.default = {
    name = "eth0";
    networkConfig = {
      Address = "10.0.0.10/24";
      Gateway = "10.0.0.1";
      DHCP = "ipv6";
    };
  };

}
