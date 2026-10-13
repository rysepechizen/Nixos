{ ... }:
{
  # Home Manager inherits this (home-manager.useGlobalPkgs = true),
  # so unfree apps in ../../home need nothing extra.
  nixpkgs.config.allowUnfree = true;
  documentation.nixos.enable = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
 nix.settings.experimental-features = [
  "nix-command"
  "flakes"
  ]; 
}
