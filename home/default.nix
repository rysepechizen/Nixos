{ ... }:
{
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./packages.nix
    ./shell.nix
    ./hide-fcitx.nix
  ];

  home.stateVersion = "26.05";
}
