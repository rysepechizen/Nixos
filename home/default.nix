# Entry point for everything user-level. Used two ways:
#   • NixOS:      modules/home-manager.nix imports it (the normal case)
#   • other distro: home/standalone.nix imports it
let
  settings = import ../settings.nix;
in
{ lib, ... }:
{
  # Same `settings` the system modules see: { settings, ... }:
  _module.args.settings = settings;

  imports = [
    ./core # shell, git, starship, fastfetch, everyday apps
    ./input # fcitx5 or ibus, picked by settings.inputMethod
    ./desktops # per-desktop config, picked by settings.desktop
  ];

  home.username = lib.mkDefault settings.user.name;
  home.homeDirectory = lib.mkDefault "/home/${settings.user.name}";

  # Do not change after install, even when upgrading Home Manager.
  home.stateVersion = settings.stateVersion;
}
