{ pkgs, ... }:

{
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3528-radxa-e20c.dtb";
    filter = "*e20c*.dtb";
  };

  # nixpkgs.overlays = [
  #   (final: super: {
  #     makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  #   })
  # ];

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../../pkgs/linux-armbian { });
  # boot.kernelPackages = pkgs.linuxPackages_testing;

  # systemd.network.networks = {
  #   eth0 = {
  #     name = "eth0";
  #     address = [
  #       "10.0.0.16/24"
  #     ];
  #     gateway = [
  #       "10.0.0.1"
  #     ];
  #     DHCP = "ipv6";
  #   };
  #   eth1 = {
  #     name = "eth1";
  #     address = [
  #       "10.0.0.18/24"
  #     ];
  #     gateway = [
  #       "10.0.0.1"
  #     ];
  #     DHCP = "ipv6";
  #   };
  # };
  systemd.network.networks.default = {
    name = "eth0";
    DHCP = "yes";
  };

}
