{ ... }:

{
  imports = [
    ./disko.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "virtio_pci"
      "usbhid"
      "sd_mod"
      "nvme"
    ];
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
