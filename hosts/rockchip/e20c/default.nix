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
      networkConfig.DHCP = true;
    };
    eth1 = {
      name = "eth1";
      networkConfig.DHCP = true;
    };
  };

}
