{
  linuxManualConfig,
  pkgs,
  fetchFromGitHub,
  ...
}:

linuxManualConfig {
  extraMeta.branch = "6.1";
  version = "6.1.75-armbian";
  modDirVersion = "6.1.75";
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    rev = "v24.11.1";
    hash = "sha256-ZqEKQyFeE0UXN+tY8uAGrKgi9mXEp6s5WGyjVuxmuyM=";
  };

  configfile = ./rk35xx_config;
  allowImportFromDerivation = true;

  kernelPatches = with pkgs.kernelPatches; [
    bridge_stp_helper
    request_key_helper
  ];

}
