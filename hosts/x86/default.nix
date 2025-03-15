{ ... }:

{
  imports = [
    ./disko.nix
  ];

  boot.loader.grub.efiSupport = true;
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
  ];
}
