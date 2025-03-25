{ ... }:

{
  imports = [
    ./disko.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot = {
        configurationLimit = 1;
        consoleMode = "auto";
        enable = true;
      };
      timeout = 1;
    };
  };
}
