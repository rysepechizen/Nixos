# Noctalia shell config → ~/.config/noctalia/
#
# Noctalia reads EVERY *.toml in that folder, sorts them by name and merges
# them. So config is split one-topic-per-file here, and any *.toml you drop
# next to this file is picked up automatically — no Nix edit needed.
#
# GUI changes (Settings window) are written to ~/.local/state/noctalia/settings.toml,
# which loads last and wins over these files. That keeps the GUI usable while
# this directory stays read-only. To make a GUI change permanent, copy it into
# the matching *.toml here; to reset to what's in the repo, delete settings.toml.
#
# "@home@" inside a file is replaced with your home directory.
#
# Not managed by Nix: plugins themselves (Noctalia fetches them at runtime;
# plugins.toml only says which are enabled) and the wallpapers folder.
{ config, lib, pkgs, ... }:
let
  home = config.home.homeDirectory;

  tomlFiles = lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".toml" name)
    (builtins.readDir ./.);
in
{
  xdg.configFile = lib.mapAttrs'
    (name: _: lib.nameValuePair "noctalia/${name}" {
      source = pkgs.writeText "noctalia-${name}" (
        builtins.replaceStrings [ "@home@" ] [ home ] (builtins.readFile (./. + "/${name}"))
      );
    })
    tomlFiles;
}
