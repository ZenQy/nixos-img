{
  fetchFromGitHub,
  linuxManualConfig,
  pkgs,
  ...
}:

let
  kernelBranch = "6.12";
  kernelVersion = "6.12.36";
in
linuxManualConfig {
  src = fetchFromGitHub {
    owner = "unifreq";
    repo = "linux-6.12.y";
    rev = "513a69bc0e74724cee598621fe173aac3d691672";
    fetchSubmodules = false;
    sha256 = "sha256-btSBASrmrGDnf0zmnxDNZs7lytqexIPHjsFc2XJfuVE=";
  };

  extraMeta.branch = kernelBranch;
  version = "${kernelVersion}-flippy";
  modDirVersion = kernelVersion;

  configfile = ./config;
  allowImportFromDerivation = true;

  kernelPatches = with pkgs.kernelPatches; [
    bridge_stp_helper
    request_key_helper
  ];
}
