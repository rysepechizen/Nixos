{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
  libreoffice-fresh
  zoom-us
  obsidian
  xed-editor
  loupe
  mpv
  papers
  atril
   ];
}
