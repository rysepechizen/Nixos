# Home Manager runs as part of `nixos-rebuild switch`: one command, one
# generation, system and home always in step.
#
# One-time setup (root's channels are what nixos-rebuild sees):
#   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
#   sudo nix-channel --update
#
# Channel-free alternative (also works in the installer / on a new machine);
# swap the import below for this, then replace the hash Nix prints on first build:
#   imports = [ "${builtins.fetchTarball {
#     url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
#     sha256 = "0000000000000000000000000000000000000000000000000000";
#   }}/nixos" ];
{ settings, ... }:
{
  imports = [
  "${builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz"}/nixos"
];

  home-manager = {
    useGlobalPkgs = true; # same pkgs (and allowUnfree) as the system
    useUserPackages = true; # packages land in /etc/profiles/per-user
    backupFileExtension = "backup"; # existing dotfiles become *.backup instead of blocking the switch
    users.${settings.user.name} = import ../home;
  };
}
