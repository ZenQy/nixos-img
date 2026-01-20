{
  fetchFromGitHub,
  linuxManualConfig,
  pkgs,
  ...
}:

let
  kernelBranch = "6.12";
  kernelVersion = "6.12.65";
in
linuxManualConfig {
  src = fetchFromGitHub {
    owner = "unifreq";
    repo = "linux-6.12.y";
    rev = "a67d28153b2c39afab74fcb8fa5b192cbb14fa6d";
    fetchSubmodules = false;
    sha256 = "sha256-jH/A74lWZG79easgceyE6wxugrHsIsLfQOdAKLa0HK4=";
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
