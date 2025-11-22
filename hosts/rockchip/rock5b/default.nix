{ pkgs, ... }:

{
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3588-rock-5b.dtb";
    filter = "*rock-5b*.dtb";
  };
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../../pkgs/linux-flippy { });
  systemd.network.networks.default = {
    name = "eth0";
    networkConfig.DHCP = true;
  };

}
