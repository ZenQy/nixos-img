{
  files = {
    "bootloader.bin" = 64;
    "env.bin" = 294912;
  };
  boot = {
    start = "12MiB";
    size = "132M";
  };
  root = {
    start = "145MiB";
  };
}
