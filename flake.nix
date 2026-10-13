
{
  description = "NixOS configuration for Latitude-5410";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.${settings.hostName} =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            # Make unstable packages available to selected modules.
            ({ pkgs, ... }: {
              _module.args.pkgs-unstable =
                import nixpkgs-unstable {
                  system = pkgs.stdenv.hostPlatform.system;
                };
            })
          ];
        };
    };
}

