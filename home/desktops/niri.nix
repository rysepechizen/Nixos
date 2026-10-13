# niri on Wayland. Compositor config lives in ./niri/, the shell in ../noctalia/.
# The system half (compositor, greeter) is modules/desktops/niri.nix.
{ pkgs, ... }:
{
  imports = [
    ./niri/config.nix # KDL tree → ~/.config/niri (validated at build time)
    ./niri/appearance.nix # cursor, GTK theme, fonts
    ../noctalia # Noctalia shell config → ~/.config/noctalia
  ];

  home.packages = with pkgs; [
    alacritty # Mod+T
    nautilus # Mod+E
    playerctl # media keys (XF86Audio*)
    xwayland-satellite # lets X11-only apps (zoom…) run under niri
  ];
}
