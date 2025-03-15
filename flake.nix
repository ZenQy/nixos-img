{
  description = "NixOS Flake for Bootstrap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    secrets = {
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
      floder =
        dir:
        filter (v: v != null) (
          attrValues (mapAttrs (k: v: if v == "directory" then k else null) (readDir dir))
        );
      hosts = concatMap (
        dir:
        map (subdir: {
          category = dir;
          name = subdir;
        }) (floder ./hosts/${dir})
      ) (floder ./hosts);

      nixos = listToAttrs (
        map (host: {
          name = host.name;
          value = nixpkgs.lib.nixosSystem {
            system = if host.category == "x86" then "x86_64-linux" else "aarch64-linux";
            specialArgs = {
              secrets = import (secrets + "/secrets.nix");
            };
            modules = [
              disko.nixosModules.disko
              ./configuration.nix
              ./grow-partition.nix
              ./hosts/${host.category}
              ./hosts/${host.category}/${host.name}
              {
                networking.hostName = host.name;
              }
            ];
          };
        }) hosts
      );

      image =
        hosts:
        listToAttrs (
          map (host: {
            name = host.name;
            value = self.nixosConfigurations.${host.name}.config.system.build.diskoImages;
          }) hosts
        );

    in

    {

      nixosConfigurations = nixos;
      packages = {
        x86_64-linux = image (filter (host: host.category == "x86") hosts);

        aarch64-linux = image (filter (host: host.category != "x86") hosts);

      };

    };
}
