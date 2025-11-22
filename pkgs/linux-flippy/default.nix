{
  fetchFromGitHub,
  linuxManualConfig,
  pkgs,
  ...
}:

let
  kernelBranch = "6.12";
  kernelVersion = "6.12.58";
in
linuxManualConfig {
  src = fetchFromGitHub {
    owner = "unifreq";
    repo = "linux-6.12.y";
    rev = "64812a9df5e4cfe09a23c608089ca4b5c6cc0ef8";
    fetchSubmodules = false;
    sha256 = "sha256-0/SlhYe7AN4DKiVmex03ZUYlX5XSCRu17E8k5ydwcEA=";
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
