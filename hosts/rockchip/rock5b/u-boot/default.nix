{
  files = {
    "idbloader.img" = 64;
    "u-boot.itb" = 16384;
  };
  boot = {
    start = "16MiB";
    size = "200M";
  };
  root = {
    start = "216MiB";
  };
}
