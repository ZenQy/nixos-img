{
  fetchFromGitHub,
  linuxManualConfig,
  pkgs,
  ...
}:

let
  kernelBranch = "6.12";
  kernelVersion = "6.12.69";
in
linuxManualConfig {
  src = fetchFromGitHub {
    owner = "unifreq";
    repo = "linux-6.12.y";
    rev = "cf31448c797d9aa8304b9f821d957582cfbec386";
    fetchSubmodules = false;
    sha256 = "sha256-fUu91hQpf28nGrFIfMNjxPEavANky4TgOSSRnoGr8JE=";
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
