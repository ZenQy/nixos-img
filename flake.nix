{
  description = "NixOS Flake for Bootstrap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
    }:
    let
      vps = [
        "natvps"
        "alice"
      ];

      nixos = builtins.listToAttrs (
        map (v: {
          name = v;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              disko.nixosModules.disko
              ./configuration.nix
              ./disko.nix
              ./grow-partition.nix
              ./vps/${v}.nix
              {
                networking.hostName = v;
              }
            ];
          };
        }) vps
      );

      image = builtins.listToAttrs (
        map (v: {
          name = v;
          value = self.nixosConfigurations.${v}.config.system.build.diskoImages;
        }) vps
      );
    in
    {

      nixosConfigurations = nixos;
      packages.x86_64-linux = image;

    };
}

# bash <(curl -L https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh) dd --password 123@@@ --img=https://claw.940940.xyz/main.raw
