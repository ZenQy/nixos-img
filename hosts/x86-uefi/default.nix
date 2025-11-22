{ ... }:

{
  imports = [
    ./disko.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
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
