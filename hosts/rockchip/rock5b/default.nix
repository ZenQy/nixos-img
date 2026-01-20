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
    networkConfig = {
      Address = "10.0.0.10/24";
      Gateway = "10.0.0.1";
      DHCP = "ipv6";
    };
  };

}
