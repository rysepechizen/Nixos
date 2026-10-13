{
  description = "NixOS configuration for Latitude-5410";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
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
          ];
        };
    };
}
