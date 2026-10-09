let
  desktop = "gnome"; # "gnome"|"kde"|"cosmic"|"xfce"|"budgie"|"cinnamon"
in
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/hardware.nix
    ./modules/audio.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/printing.nix
    ./modules/fonts.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/nix.nix
    ./modules/swap.nix
    ./modules/btrfs.nix

    # Desktop chosen by the line at the top of this file
    ./modules/${desktop}.nix
  ];

  # Host-specific identity
  networking.hostName = "Latitude-5410";

  # Do not change after install, even when upgrading NixOS.
  system.stateVersion = "26.05";
}
