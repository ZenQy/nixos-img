{ ... }:

{
  imports = [
    ./disko.nix
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    loader.generic-extlinux-compatible.configurationLimit = 2;

    kernelParams = [
      "console=ttyS0,1500000"
    ];
  };

}
