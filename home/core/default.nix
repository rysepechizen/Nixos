# Desktop-independent user setup.
{ ... }:
{
  imports = [
    ./shell.nix
    ./starship.nix
    ./git.nix
    ./fastfetch.nix
    ./packages.nix
  ];
}
