# Everything that belongs to the OS (root-level). User-level apps and dotfiles
# live in ../home and are pulled in through ./home-manager.nix.
{ ... }:
{
  imports = [
    # ── core: the base system ──
    ./core/boot.nix
    ./core/nix.nix
    ./core/locale.nix
    ./core/users.nix
    ./core/networking.nix
    ./core/fonts.nix
    ./core/packages.nix

    # ── hardware: what this particular machine needs ──
    ./hardware/graphics.nix
    ./hardware/intel.nix
    ./hardware/audio.nix
    ./hardware/laptop.nix
    ./hardware/printing.nix
    ./hardware/btrfs.nix
    ./hardware/swap.nix

    # ── input method: ibus only (fcitx5 lives in ../home/input) ──
    ./input

    # ── desktop: picked by `desktop` in settings.nix ──
    ./desktops

    # ── home: Home Manager as part of this same rebuild ──
    ./home-manager.nix
  ];
}
