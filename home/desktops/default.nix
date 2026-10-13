# Per-desktop user config. Loads ./<desktop>.nix for the desktop chosen in
# settings.nix, if such a file exists (KDE, COSMIC, XFCE… need none).
let
  settings = import ../../settings.nix;
in
{
  imports = builtins.filter builtins.pathExists [ ./${settings.desktop}.nix ];
}
