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
          system = if dir == "x86" || dir == "x86-uefi" then "x86_64-linux" else "aarch64-linux";
          dir = dir;
          name = subdir;
        }) (floder ./hosts/${dir})
      ) (floder ./hosts);

      nixos = listToAttrs (
        map (host: {
          name = host.name;
          value = nixpkgs.lib.nixosSystem {
            system = host.system;
            modules = [
              disko.nixosModules.disko
              ./configuration.nix
              ./grow-partition.nix
              ./hosts/${host.dir}
              ./hosts/${host.dir}/${host.name}
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
        x86_64-linux = image (filter (host: host.system == "x86_64-linux") hosts);

        aarch64-linux = image (filter (host: host.system == "aarch64-linux") hosts);

      };

    };
}
