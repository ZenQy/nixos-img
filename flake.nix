{
  description = "NixOS Flake for Bootstrap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    secrets = {
      # url = "/home/nixos/Documents/nixos-secrets";
      url = "git+ssh://git@github.com/zenqy/nixos-secrets";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      secrets,
      disko,
    }:
    with builtins;
    let
      vps = map (n: substring 0 ((stringLength n) - 4) n) (attrNames (readDir ./vps));

      nixos = listToAttrs (
        map (v: {
          name = v;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              secrets = import (secrets + "/secrets.nix");
            };
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

      image = listToAttrs (
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
