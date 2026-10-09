{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
  libreoffice-fresh
  zoom-us
  obsidian
  neovim
   ];
}
