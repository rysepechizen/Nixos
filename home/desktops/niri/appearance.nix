{ pkgs, settings, ... }:
{
  home.packages = with pkgs; [
    orchis-theme
    tela-icon-theme
  ];

  home.pointerCursor = {
    name = settings.cursor.name;
    package = pkgs.${settings.cursor.package};
    size = settings.cursor.size;
    gtk.enable = true;
  };

  # GTK apps read these through dconf (programs.dconf.enable is in modules/desktops/common.nix).
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    font-name = "Inter 12";
    document-font-name = "Inter 12";
    monospace-font-name = "JetBrainsMono Nerd Font 12";
    gtk-theme = "Orchis-Dark";
    icon-theme = "Tela-dark";
  };
}
