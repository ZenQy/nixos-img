# This module automatically grows the root partition.
# This allows an instance to be created with a bigger root filesystem
# than provided by the machine image.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{

  systemd.services.growpart =
    let
      mountPoint = "/";
      device = config.fileSystems.${mountPoint}.device;
      isBtrfs = config.fileSystems.${mountPoint}.fsType == "btrfs";
    in
    {
      enable = true;
      wantedBy = [ "-.mount" ];
      after = [ "-.mount" ];
      before = [
        "systemd-growfs-root.service"
        "shutdown.target"
        "mkswap-.service"
      ];
      conflicts = [ "shutdown.target" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutSec = "infinity";
        # growpart returns 1 if the partition is already grown
        SuccessExitStatus = "0 1";
      };
      path =
        with pkgs;
        [
          cloud-utils.guest
        ]
        ++ optional isBtrfs btrfs-progs;
      script = ''
        device="$(readlink -f "${device}")"
        parentDevice="$device"
        while [ "''${parentDevice%[0-9]}" != "''${parentDevice}" ]; do
          parentDevice="''${parentDevice%[0-9]}";
        done
        partNum="''${device#''${parentDevice}}"
        if [ "''${parentDevice%[0-9]p}" != "''${parentDevice}" ] && [ -b "''${parentDevice%p}" ]; then
          parentDevice="''${parentDevice%p}"
        fi
        growpart "$parentDevice" "$partNum"
      ''
      + optionalString isBtrfs ''
        btrfs filesystem resize max ${mountPoint}
      '';
    };
}
