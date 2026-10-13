# System-wide basics only. Apps you use yourself belong in ../../home/core/packages.nix.
{ pkgs, ... }:
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
  ];
}
