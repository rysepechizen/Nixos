# NixOS configuration

This repo is made for my personal use. If it helps you in any way feel fre to use it.It's my NixOS 26.05 setup for a Dell Latitude 5410, managed with **channels** (no flakes) and **Home Manager**. One file per topic, so every part of the system can be read, changed or switched off on its own.

| | |
|---|---|
| **Host** | `Latitude-5410` (Intel, ~7.3 GiB RAM) |
| **NixOS** | 26.05 (`system.stateVersion = "26.05"`) |
| **User** | `sanzay` |
| **Package source** | `nixos` (nixos-26.05) and `home-manager` (release-26.05) channels |
| **Filesystem** | btrfs with zstd compression, zram swap plus an 8 GiB swapfile |
| **Desktops** | GNOME, KDE Plasma 6 (one active at a time) | (Can be switched from configuration.nix)

## What's in it

- **Boot:** systemd-boot, hidden menu (hold <kbd>Space</kbd> to open it), Plymouth `spinner` theme and a silent boot.
- **Hardware:** Intel microcode, redistributable firmware, `thermald`, graphics, PipeWire audio, NetworkManager, printing.
- **Storage:** btrfs mount options (`compress=zstd`, `noatime`) in `modules/btrfs.nix`, `zramSwap` plus a btrfs-safe swapfile in `modules/swap.nix`.
- **Fonts:** Noto, Inter, Meslo and JetBrains Mono Nerd Fonts, with Noto Devanagari fallbacks.
- **Nepali input:** `fcitx5` + `fcitx5-m17n` on KDE, `ibus` + `ibus-engines.m17n` on GNOME (traditional layout, `ne-trad-ttf`).
- **Home Manager:** bash, Starship (Catppuccin Mocha powerline prompt), fastfetch, bat, git.
- **Nix:** unfree packages allowed, weekly garbage collection of anything older than 7 days.

## Layout

```
.
├── configuration.nix            # imports, hostname, stateVersion only
├── hardware-configuration.nix   # generated for this machine, do not reuse
├── modules/                     # system side, one file per topic
│   ├── boot.nix       hardware.nix    audio.nix     networking.nix
│   ├── locale.nix     printing.nix    fonts.nix     users.nix
│   ├── packages.nix   nix.nix         swap.nix      btrfs.nix
│   ├── home.nix       # Home Manager glue
│   ├── gnome.nix      # GNOME + IBus
│   └── kde.nix        # Plasma 6 + fcitx5
└── home/                        # user side (Home Manager)
    ├── default.nix    git.nix       fastfetch.nix
    ├── packages.nix   shell.nix     hide-fcitx.nix
    └── starship.toml
```

Only one desktop module is imported at a time (see `configuration.nix`), because the display manager and the input method can't be defined twice.

## Usage

Rebuild after any change, checking first that nothing will be compiled:

```bash
sudo nixos-rebuild dry-build   # "paths will be fetched" is fine; stop if Qt/quickshell etc. would be built
sudo nixos-rebuild switch
```

Back up changes to this repo:

```bash
cd /etc/nixos
git add -A
git commit -m "describe the change"
git push
```

### Switching desktops

Comment out the current desktop module in `configuration.nix`, enable the other (`gnome.nix` or `kde.nix`), rebuild, then log out and back in. On KDE, select **Fcitx 5** under *System Settings → Virtual Keyboard*. On GNOME, add the Nepali m17n entry under *Settings → Keyboard → Input Sources*.

## Setting it up on another machine

1. Install NixOS 26.05 and add the channels:

   ```bash
   sudo nix-channel --add https://nixos.org/channels/nixos-26.05 nixos
   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
   sudo nix-channel --update
   ```

2. Clone this repo into `/etc/nixos`, then **regenerate `hardware-configuration.nix` for the new machine** (`nixos-generate-config`), and change `networking.hostName` and the user name to match.
3. Run `sudo nixos-rebuild dry-build`, then `sudo nixos-rebuild switch`.

## Notes

- **This laptop can't compile large packages** (it overheats and runs out of RAM), so the config only uses cached nixpkgs binaries. Always run `dry-build` first.
- Home Manager option names change between releases, so check them against the 26.05 docs before editing.
- Deleting a block in a `.nix` file can leave a stray `];` and cause a parse error. Read the error's line number first.
- Dotfiles managed by Nix are read-only symlinks into the store. Edit the source in this repo and rebuild.

## Planned

- Try [niri](https://github.com/YaLTeR/niri) with the Noctalia shell, using only nixpkgs packages (no flake inputs).

## Credits

- [NixOS](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)
- [Catppuccin](https://github.com/catppuccin/catppuccin) for the Starship palette
