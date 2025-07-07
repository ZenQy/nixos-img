{
  fetchFromGitHub,
  linuxManualConfig,
  pkgs,
  ...
}:

let
  kernelBranch = "6.1";
  kernelVersion = "6.1.75";
in
linuxManualConfig {
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    rev = "v24.11.1";
    hash = "sha256-ZqEKQyFeE0UXN+tY8uAGrKgi9mXEp6s5WGyjVuxmuyM=";
  };

  extraMeta.branch = kernelBranch;
  version = "${kernelVersion}-armbian";
  modDirVersion = kernelVersion;

  configfile = ./config;
  allowImportFromDerivation = true;

  kernelPatches = with pkgs.kernelPatches; [
    bridge_stp_helper
    request_key_helper
  ];

}
