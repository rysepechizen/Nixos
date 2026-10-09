{ ... }:
{
  imports = [
    ./git.nix
    ./fastfetch.nix
    ./packages.nix
    ./shell.nix
    ./hide-fcitx.nix
    ./Gnome-settings.nix
  ];
  home.username = "sanzay";
  home.homeDirectory = "/home/sanzay";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
