{...}:

{
  imports = [
    ./disko.nix
  ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
  ];
}
