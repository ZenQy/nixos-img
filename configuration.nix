{
  config,
  lib,
  ...
}:

{
  nix.extraOptions = "experimental-features = nix-command flakes";
  services.openssh = {
    enable = true;
    ports = [
      22
      2022
    ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "prohibit-password";
    };
  };
  users.users.root = {
    hashedPassword = "$6$4pRV3Gia$3OfrxJ8V95zIGk1D7p/fR5/brb8s5okIYpmIvSYXCPmuzd7AaibroCvPwfOUxokcHJb.HnqwZ2xsbJCutGwvp/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCm/fzBKSSrwR8taYQURb/0p21tBpk6QCL9JviqUOvj zenith@linux"
    ];
  };
  environment.etc."ssh/ssh_host_ed25519_key.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ45CA7BpSSt3qrC64G4/uZsSzH8Fzi5bZW30EOaN2Y8 root@nixos-img";

  networking.firewall.enable = false;
  networking.useDHCP = false;
  systemd.network.enable = true;
  services.resolved.enable = false;
  networking.nameservers = [
    "1.1.1.1"
    "2606:4700:4700::1111"
  ];

  time.timeZone = "Asia/Shanghai";

  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
  ];

  system.stateVersion = builtins.substring 0 5 config.system.nixos.version;
}
