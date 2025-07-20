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
    networkConfig.DHCP = true;
  };

}
