# Entry point for NON-NixOS machines (any distro with Nix + Home Manager):
#   home-manager switch -b backup -f ~/nixos/home/standalone.nix
# On NixOS don't use this; nixos-rebuild applies ./default.nix for you.
{ ... }:
{
  imports = [ ./default.nix ];

  nixpkgs.config.allowUnfree = true; # NixOS gets this from modules/core/nix.nix
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
