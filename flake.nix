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
      inherit (builtins)
        filter
        attrNames
        readDir
        concatMap
        listToAttrs
        substring
        ;
      floder =
        dir:
        let
          files = readDir dir;
        in
        filter (name: files.${name} == "directory") (attrNames files);

      hosts = concatMap (
        dir:
        map (subdir: {
          system = if (substring 0 3 dir) == "x86" then "x86_64-linux" else "aarch64-linux";
          inherit dir;
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
        system:
        listToAttrs (
          map (host: {
            name = host.name;
            value = nixos.${host.name}.config.system.build.diskoImages;
          }) (filter (host: host.system == system) hosts)
        );

    in

    {
      nixosConfigurations = nixos;
      packages = {
        x86_64-linux = image "x86_64-linux";
        aarch64-linux = image "aarch64-linux";
      };
    };
}
