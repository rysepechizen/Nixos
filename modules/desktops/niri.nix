# niri (Wayland) + Noctalia shell + Noctalia greeter.
# The user-side half (keybinds, layout, shell config) is home/desktops/niri.nix.
{ pkgs, pkgs-unstable, settings, ... }:
{
  imports = [ ./niri/greeter.nix ];

  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs-unstable.noctalia # the shell: bar, launcher, lock screen, notifications
    pkgs.${settings.cursor.package}
  ];
}
