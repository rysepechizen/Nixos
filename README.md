<div align="center">

# ❄️ NixOS — Personal, Modular Desktop Configuration

**A customizable NixOS + Home Manager setup with a Wayland-first workflow, Niri, Noctalia, and modular desktop options.**

*One settings file. Separated system and user modules. A starting point you can make your own.*

[![NixOS](https://img.shields.io/badge/NixOS-configuration-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-integrated-7EBAE4)](https://github.com/nix-community/home-manager)
[![Niri](https://img.shields.io/badge/Wayland-Niri-6B8E23)](https://github.com/niri-wm/niri)
[![Noctalia](https://img.shields.io/badge/Shell-Noctalia-9B8AC4)](https://github.com/noctalia-dev/noctalia)

</div>

---

## ✨ About

This repository is a personal, modular NixOS configuration intended to be understandable and adaptable—not a one-size-fits-all system image. It separates **system configuration** (services, boot, hardware and desktop session) from **user configuration** (applications, shell, compositor settings and desktop-shell appearance).

The default profile is built around **Niri**, a scrollable tiling Wayland compositor, and **Noctalia**, which supplies the desktop shell experience. Several other desktop choices are represented in the system modules. The configuration also integrates [Home Manager](https://github.com/nix-community/home-manager), so a normal NixOS rebuild applies the OS and the configured user's dotfiles together.

> **Important:** This repository is a template and a record of one machine's configuration. Review it before using it. It is not guaranteed to work unchanged on every computer. In particular, `hardware-configuration.nix`, the username, bootloader, disk layout, CPU-specific modules, monitor names and state versions are machine-specific.

## 📚 Contents

- [Highlights](#-highlights)
- [Repository structure](#-repository-structure)
- [How `settings.nix` controls the setup](#️-how-settingsnix-controls-the-setup)
- [Applications and tools](#-applications-and-tools)
- [Desktop and shell configuration](#️-desktop-and-shell-configuration)
- [Installation and first build](#-installation-and-first-build)
- [Everyday workflow](#-everyday-workflow)
- [Personalization guide](#-personalization-guide)
- [Troubleshooting](#-troubleshooting)
- [Credits and acknowledgements](#-credits-and-acknowledgements)

## 🌟 Highlights

- **Central settings:** common per-machine values live in `settings.nix`.
- **System/user separation:** `modules/` manages NixOS; `home/` manages the user's apps and dotfiles.
- **Home Manager integration:** `sudo nixos-rebuild switch` applies both layers in one workflow.
- **Niri configuration split into small files:** display, input, layout, animations, keybinds, window rules and autostart are maintained separately.
- **Noctalia configuration split by topic:** bar, shell, theme, wallpaper, widgets, lock screen, idle behavior, plugins and control center.
- **Build-time Niri validation:** the Home Manager Niri module validates the assembled configuration during the build.
- **Desktop alternatives:** system modules are present for GNOME, KDE Plasma, COSMIC, XFCE, Budgie and Cinnamon as well as Niri.
- **A familiar terminal workflow:** Bash aliases, Starship prompt, Fastfetch system summary and Git configuration.

## 🗂️ Repository structure

```text
.
├── configuration.nix                 # NixOS entry point
├── settings.nix                      # Shared per-machine / per-user settings
├── hardware-configuration.nix        # Generated disk and hardware configuration
├── modules/                           # System-wide NixOS modules
│   ├── default.nix                    # Imports the system module collection
│   ├── home-manager.nix                # Integrates Home Manager into rebuilds
│   ├── core/
│   │   ├── boot.nix                    # Limine, Plymouth and quiet boot
│   │   ├── fonts.nix                   # System fonts and font fallbacks
│   │   ├── locale.nix                  # Time zone and locale from settings.nix
│   │   ├── networking.nix              # Host name and NetworkManager
│   │   ├── nix.nix                     # Unfree packages, documentation and GC
│   │   ├── packages.nix                # System-wide essentials
│   │   └── users.nix                   # Main user and group membership
│   ├── hardware/
│   │   ├── audio.nix                   # PipeWire / PulseAudio compatibility
│   │   ├── btrfs.nix                   # Btrfs mount options
│   │   ├── graphics.nix                # Graphics support and firmware
│   │   ├── intel.nix                   # Intel CPU microcode and thermald
│   │   ├── laptop.nix                  # Power profiles, UPower and Bluetooth
│   │   ├── printing.nix                # Printing service
│   │   └── swap.nix                    # zram swap
│   └── desktops/
│       ├── default.nix                 # Selects desktop module from settings.nix
│       ├── common.nix                  # Shared desktop plumbing
│       ├── niri.nix                    # Niri and Noctalia shell packages
│       ├── niri/greeter.nix             # greetd + Noctalia greeter
│       ├── gnome.nix                   # GNOME session
│       ├── kde.nix                     # KDE Plasma 6 session
│       ├── cosmic.nix                  # COSMIC session
│       ├── xfce.nix                    # XFCE session
│       ├── budgie.nix                  # Budgie session
│       └── cinnamon.nix                # Cinnamon session and panel defaults
└── home/                               # User-level Home Manager configuration
    ├── default.nix                     # Home Manager entry point
    ├── standalone.nix                  # Entry point for non-NixOS Home Manager
    ├── core/
    │   ├── default.nix                 # Imports shared user modules
    │   ├── packages.nix                # User applications
    │   ├── shell.nix                   # Bash aliases, Fastfetch startup, bat
    │   ├── git.nix                     # Git identity
    │   ├── fastfetch.nix                # Fastfetch layout
    │   ├── starship.nix                 # Enables Starship
    │   └── starship.toml                # Starship prompt theme
    ├── input/
    │   ├── default.nix                 # Selects input-method module
    │   ├── fcitx5.nix                  # Fcitx5 configuration
    │   └── ibus.nix                    # IBus configuration
    ├── desktops/
    │   ├── default.nix                 # Imports matching user desktop module if present
    │   ├── niri.nix                    # Niri-specific applications and imports
    │   ├── gnome.nix                   # GNOME-specific Home Manager settings
    │   └── niri/
    │       ├── config.nix              # Installs and validates Niri config tree
    │       ├── appearance.nix          # Cursor, GTK theme and fonts
    │       ├── config.kdl              # Main Niri config and includes
    │       └── cfg/
    │           ├── animation.kdl       # Animations
    │           ├── autostart.kdl       # Programs launched with the session
    │           ├── display.kdl         # Monitor/output configuration
    │           ├── input.kdl           # Keyboard, mouse and touchpad
    │           ├── keybinds.kdl        # Keyboard shortcuts
    │           ├── layout.kdl          # Tiling/layout behavior
    │           ├── misc.kdl            # Other compositor options
    │           └── rules.kdl           # Window rules
    └── noctalia/
        ├── default.nix                 # Links Noctalia TOML configuration
        ├── bar.toml                   # Bar
        ├── control-center.toml         # Control center
        ├── idle.toml                  # Idle behavior
        ├── lockscreen.toml             # Lock screen
        ├── plugins.toml                # Plugins
        ├── shell.toml                  # General shell settings
        ├── theme.toml                  # Theme and colors
        ├── wallpaper.toml              # Wallpaper settings
        └── widgets.toml                 # Desktop widgets
```

### What belongs where?

- **`configuration.nix`** is the small top-level entry point. It imports the generated hardware file and `modules/`, passes `settings.nix` to system modules, and sets `system.stateVersion`.
- **`modules/`** contains machine-wide operating-system settings: boot, users, networking, hardware services, system packages and the selected desktop session.
- **`home/`** contains user-specific settings: user packages, shell programs, Niri dotfiles, Noctalia TOML files and input methods.
- **`settings.nix`** is the common source for the hostname, time zone, locale, desktop choice, username, cursor and related settings.
- **`hardware-configuration.nix`** is generated by NixOS and describes this installation's hardware and mount points. Generate a correct one for your own installation; do not reuse another machine's disk UUIDs.
- **`home/standalone.nix`** is for using Home Manager on a non-NixOS Linux distribution. It is not the normal entry point on NixOS.

## ⚙️ How `settings.nix` controls the setup

This is the main file to inspect when adapting the configuration to a new machine. Both NixOS modules and Home Manager read it, so changing a shared value can affect more than one layer.

The current file defines:

```nix
let
  desktop = "niri";
  x11Desktops = [ "xfce" "budgie" "cinnamon" ];
in
{
  inherit desktop;

  hostName = "Latitude-5410";
  timeZone = "Asia/Kathmandu";
  locale = "en_US.UTF-8";
  stateVersion = "26.05";

  user = {
    name = "sanzay";
    description = "Nixos";
  };

  inputMethod = if desktop == "xfce" then "ibus" else "fcitx5";
  isX11 = builtins.elem desktop x11Desktops;

  cursor = {
    name = "Bibata-Modern-Ice";
    package = "bibata-cursors";
    size = 24;
  };
}
```

The values above are the repository's current defaults, **not values you should blindly copy**. Change the username and host name to match your installation.

| Setting | What it affects | What to consider |
|---|---|---|
| `desktop` | Selects `modules/desktops/<desktop>.nix`; Home Manager also tries to import `home/desktops/<desktop>.nix` if that file exists. | Choose a desktop module that exists in both the system-side selector and the available user-side modules. |
| `hostName` | Sets `networking.hostName`. | Use a valid host name for this computer. |
| `timeZone` | Sets `time.timeZone`. | Use an IANA time zone such as `Asia/Kathmandu` or `Europe/Berlin`. |
| `locale` | Sets `i18n.defaultLocale`. | The locale must be supported/generated by the system. |
| `stateVersion` | Sets NixOS `system.stateVersion` and Home Manager `home.stateVersion`. | Preserve the value chosen when this installation was first configured. It is not simply a version number to bump during upgrades. |
| `user.name` | Creates/selects the system user and determines which Home Manager user is configured and the home path. | Make this match the intended Linux account. Renaming a Linux account requires more than changing this string. |
| `user.description` | Sets the account's descriptive/full-name field. | Personalize if desired. |
| `inputMethod` | Selects `home/input/fcitx5.nix` or `home/input/ibus.nix`. | Currently `xfce` automatically chooses IBus; other desktops choose Fcitx5. |
| `isX11` | Indicates whether the chosen desktop is in the configured X11 desktop list; used by input-method settings. | If you add or change desktop modules, update this list if the session type differs. |
| `cursor.name`, `cursor.package`, `cursor.size` | Used by cursor/appearance configuration and the Niri Noctalia greeter. | Keep the package attribute and theme name consistent with the cursor package. |

### Why the shared settings matter

The system entry point imports `settings.nix` and passes it to NixOS modules through `_module.args.settings`. Home Manager imports the same file and exposes it to the user modules. That is why one setting can keep the host name, user, locale, input method and desktop selection aligned across both halves.

The desktop selectors use the `desktop` string to build import paths. A valid selection therefore needs a corresponding file under `modules/desktops/`. The Home Manager selector imports a same-named file only when one exists, so a system desktop may not have custom user-side configuration.

**Before changing desktops:** inspect both `modules/desktops/` and `home/desktops/`, and read the selected module. Different desktops may need different display managers, X11/Wayland handling, input-method setup and shell components. Do not assume changing only `desktop` fully converts every desktop-specific preference.

## 🧰 Applications and tools

The following list reflects the packages and programs explicitly enabled in this repository. Nix package names and upstream project names can differ.

| Application | Purpose in this setup | Upstream project |
|---|---|---|
| [NixOS](https://github.com/NixOS) | Declarative Linux operating system and system configuration | [NixOS GitHub](https://github.com/NixOS) |
| [Home Manager](https://github.com/nix-community/home-manager) | Manages user packages and dotfiles alongside NixOS rebuilds | [nix-community/home-manager](https://github.com/nix-community/home-manager) |
| [Niri](https://github.com/niri-wm/niri) | Scrollable tiling Wayland compositor; selected by default | [niri-wm/niri](https://github.com/niri-wm/niri) |
| [Noctalia Shell](https://github.com/noctalia-dev/noctalia) | Desktop shell: bar, launcher, widgets, notifications, lock screen and wallpaper controls | [noctalia-dev/noctalia](https://github.com/noctalia-dev/noctalia) |
| [Noctalia Greeter](https://github.com/noctalia-dev/noctalia) | Login greeter integration used with `greetd` in the Niri profile | Noctalia project |
| [Firefox](https://github.com/mozilla/firefox) | System-enabled web browser | [mozilla/firefox](https://github.com/mozilla/firefox) |
| [Alacritty](https://github.com/alacritty/alacritty) | Terminal emulator; configured as the Niri terminal shortcut | [alacritty/alacritty](https://github.com/alacritty/alacritty) |
| [Nautilus](https://gitlab.gnome.org/GNOME/nautilus) | File manager; used by the Niri file-manager shortcut | [GNOME Nautilus](https://gitlab.gnome.org/GNOME/nautilus) |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | Shows a system summary when Bash starts | [fastfetch-cli/fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| [Starship](https://github.com/starship/starship) | Configurable shell prompt, themed with `home/core/starship.toml` | [starship/starship](https://github.com/starship/starship) |
| [bat](https://github.com/sharkdp/bat) | `cat`-style file viewer with syntax highlighting; enabled through Home Manager | [sharkdp/bat](https://github.com/sharkdp/bat) |
| [Git](https://github.com/git/git) | Version control; configured through Home Manager and also available system-wide | [git/git](https://github.com/git/git) |
| [Neovim](https://github.com/neovim/neovim) | Terminal text editor | [neovim/neovim](https://github.com/neovim/neovim) |
| [Xed](https://github.com/linuxmint/xed) | Graphical text editor | [linuxmint/xed](https://github.com/linuxmint/xed) |
| [LibreOffice](https://github.com/LibreOffice/core) | Office suite (`libreoffice-fresh`) | [LibreOffice/core](https://github.com/LibreOffice/core) |
| [Obsidian](https://obsidian.md/) | Notes and knowledge management app (proprietary) | [Obsidian website](https://obsidian.md/) |
| [Zoom](https://zoom.us/) | Video meetings (`zoom-us`, proprietary) | [Zoom website](https://zoom.us/) |
| [playerctl](https://github.com/altdesktop/playerctl) | Media-player control, used for media-key handling | [altdesktop/playerctl](https://github.com/altdesktop/playerctl) |
| [xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite) | XWayland support for X11 applications under Niri | [Supreeeme/xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite) |
| [wget](https://git.savannah.gnu.org/cgit/wget.git) | Command-line download utility, installed system-wide | [GNU Wget](https://www.gnu.org/software/wget/) |
| [PipeWire](https://github.com/PipeWire/pipewire) | Audio server and compatibility layers | [PipeWire](https://github.com/PipeWire/pipewire) |
| [Fcitx5](https://github.com/fcitx/fcitx5) | Input-method framework selected for most configured desktops | [fcitx/fcitx5](https://github.com/fcitx/fcitx5) |
| [IBus](https://github.com/ibus/ibus) | Alternative input-method framework selected for XFCE | [ibus/ibus](https://github.com/ibus/ibus) |
| [Limine](https://github.com/limine-bootloader/limine) | Bootloader configured by `modules/core/boot.nix` | [limine-bootloader/limine](https://github.com/limine-bootloader/limine) |
| [Plymouth](https://github.com/plymouth/plymouth) | Boot splash; this configuration fetches a separate mac-style theme | [plymouth/plymouth](https://github.com/plymouth/plymouth) |

Other desktop modules may enable components supplied by GNOME, KDE Plasma, COSMIC, XFCE, Budgie or Cinnamon. These are selected through `settings.nix`; not all are active in the default Niri setup.

## 🖥️ Desktop and shell configuration

### Niri: compositor configuration

Edit files under `home/desktops/niri/cfg/` for focused changes:

- `display.kdl` — monitor names, modes, scale and arrangement. **Review this first on a new monitor or computer.**
- `input.kdl` — keyboard, pointer and touchpad behavior.
- `keybinds.kdl` — keyboard shortcuts.
- `layout.kdl` — gaps, borders and tiling/layout preferences.
- `animation.kdl` — animation behavior.
- `autostart.kdl` — applications/services started with the session.
- `rules.kdl` — per-window behavior and matching rules.
- `misc.kdl` — other Niri options.
- `config.kdl` — main file that includes the smaller configuration files.

The Niri Home Manager module builds a configuration tree and runs `niri validate` against it before applying it. Validation is enabled in `home/desktops/niri/config.nix`. If validation fails, fix the reported KDL syntax/configuration issue instead of bypassing it as a first response.

### Noctalia: desktop shell

The TOML files under `home/noctalia/` split shell settings by topic:

- `bar.toml` — bar layout and behavior.
- `control-center.toml` — quick settings/control center.
- `idle.toml` — idle behavior.
- `lockscreen.toml` — lock-screen settings.
- `plugins.toml` — plugin configuration.
- `shell.toml` — general shell settings.
- `theme.toml` — theme and colors.
- `wallpaper.toml` — wallpaper behavior.
- `widgets.toml` — desktop widgets.

The repository links these files into `~/.config/noctalia`. Noctalia can also save GUI changes into `~/.local/state/noctalia/settings.toml`; depending on the setting and Noctalia version, that runtime state may override repository defaults. If changes in the TOML files do not appear, inspect the Noctalia GUI/state and back up any settings you want to keep before resetting runtime state. Avoid deleting the state file blindly if it contains preferences you care about.

### Starship, Bash, Fastfetch and Git

- `home/core/starship.toml` defines the prompt's format, palette and language/version modules.
- `home/core/shell.nix` enables Bash, enables `bat`, sets `ls` and `grep` color aliases, defines `rebuild`, and runs `fastfetch` at Bash startup.
- `home/core/fastfetch.nix` configures the NixOS logo and the system-information modules shown.
- `home/core/git.nix` sets a Git author name and email. Replace these with your own identity before making commits from your own machine.

### Appearance and cursor

`home/desktops/niri/appearance.nix` handles user-session appearance such as cursor, GTK theme and fonts. `settings.nix` contains the cursor theme name, Nix package attribute and size, and the Niri greeter uses the shared cursor values too.

## 🚀 Installation and first build

These instructions assume a **fresh or already working NixOS installation** and a user who understands how to recover from a failed system rebuild. Keep a working recovery generation available.

### 1. Back up your current configuration

```bash
sudo cp -a /etc/nixos "/etc/nixos.backup-$(date +%F)"
```

If `/etc/nixos` is managed by Git, commit or otherwise preserve your current working version first.

### 2. Review and adapt the repository

Copy the repository into `/etc/nixos` or merge its files into your existing configuration. Do not overwrite your own generated `hardware-configuration.nix` with the one in this archive.

At minimum, review:

1. `settings.nix` — set `user.name`, `user.description`, `hostName`, time zone and desktop.
2. `hardware-configuration.nix` — keep the file generated for your own machine.
3. `modules/hardware/intel.nix` — this module is Intel-specific. For AMD or another platform, replace/adapt it and adjust `modules/default.nix`.
4. `modules/hardware/btrfs.nix` — only use these mount options if the relevant filesystems are Btrfs and the mount points match.
5. `home/desktops/niri/cfg/display.kdl` — adjust output names and modes to your monitors.
6. `home/core/git.nix` — set your Git identity.
7. `modules/core/boot.nix` — check the Limine/EFI/Plymouth assumptions against your installation.

The account configured in `settings.nix` must exist or be created correctly by NixOS. If migrating an existing account, verify the username and home directory before switching.

### 3. Make Home Manager available

This configuration imports the Home Manager NixOS module from the `release-26.05` archive in `modules/home-manager.nix`. Ensure the selected NixOS and Home Manager versions are compatible. If you use channels, the repository comments document a channel-based setup; this configuration currently uses `builtins.fetchTarball`, so the import path itself is fetched by Nix.

### 4. Check the configuration

From the configuration directory:

```bash
sudo nixos-rebuild build
```

This builds without switching the running system. Resolve errors before continuing. On a supported NixOS version, you can also inspect the configuration with the appropriate `nix flake`/evaluation tools if you convert the project to flakes, but **this repository is not currently a flake-based configuration**.

### 5. Apply it

```bash
sudo nixos-rebuild switch
```

The Bash alias `rebuild` is defined for convenience after the Home Manager configuration has been applied. It runs `sudo nixos-rebuild switch`.

Log out and back in if your desktop session, compositor or user services need to restart. Keep the previous boot generation until you've confirmed that the system works.

### Standalone Home Manager on another Linux distribution

`home/standalone.nix` is a separate entry point intended for a non-NixOS system that already has Nix and Home Manager configured. Its comment gives this command:

```bash
home-manager switch -b backup -f ~/nixos/home/standalone.nix
```

Adjust the path to where you cloned/copied this repository. The standalone path only manages user-level configuration; it does **not** configure NixOS system services, boot, hardware, or desktop-manager services.

## 🔁 Everyday workflow

1. Edit the relevant `.nix`, `.kdl` or `.toml` file.
2. Build first to catch errors:

   ```bash
   sudo nixos-rebuild build
   ```

3. Apply after the build succeeds:

   ```bash
   sudo nixos-rebuild switch
   ```

4. If a change affects the compositor or desktop shell, log out and back in or restart the relevant component as appropriate.

### Where to make common changes

| Goal | File(s) to edit |
|---|---|
| Change desktop session | `settings.nix`, then inspect `modules/desktops/` and `home/desktops/` |
| Change hostname, locale or time zone | `settings.nix` |
| Add/remove user applications | `home/core/packages.nix` |
| Add/remove system-wide applications | `modules/core/packages.nix` |
| Change shell prompt | `home/core/starship.toml` |
| Change Fastfetch output | `home/core/fastfetch.nix` |
| Change Bash aliases | `home/core/shell.nix` |
| Change Git identity | `home/core/git.nix` |
| Change Niri keybinds | `home/desktops/niri/cfg/keybinds.kdl` |
| Change monitors | `home/desktops/niri/cfg/display.kdl` |
| Change window rules | `home/desktops/niri/cfg/rules.kdl` |
| Change Niri layout/animations | `home/desktops/niri/cfg/layout.kdl`, `animation.kdl` |
| Change startup applications | `home/desktops/niri/cfg/autostart.kdl` |
| Change Noctalia bar or widgets | `home/noctalia/bar.toml`, `widgets.toml` |
| Change Noctalia theme/wallpaper | `home/noctalia/theme.toml`, `wallpaper.toml` |
| Change audio, printing, Bluetooth or power services | Matching file under `modules/hardware/` |
| Change boot behavior | `modules/core/boot.nix` |

## 🧩 Personalization and contribution ideas

This is meant to be forked and tailored. A few practical principles:

- **Prefer small modules.** Put a setting in the file responsible for that area instead of growing one giant `configuration.nix`.
- **Keep hardware-specific choices explicit.** A laptop module, Intel CPU module and Btrfs options should only be enabled when they match the target machine.
- **Keep secrets out of Git.** Do not commit passwords, private keys, tokens or sensitive machine-specific information.
- **Review upstream changes.** NixOS, Home Manager, Niri and Noctalia can change options between versions.
- **Validate before switching.** Use `nixos-rebuild build` first and preserve a rollback path.
- **Share improvements.** If you adapt this for another machine or desktop, document the assumptions and send a pull request to your own fork or upstream where appropriate.

## 🛠️ Troubleshooting

### Build fails after editing Niri

Read the exact `niri validate` error and inspect the named file under `home/desktops/niri/`. KDL syntax is strict; a setting valid in another compositor or Niri version may not be valid here. Check the installed Niri version and its documentation.

### A Noctalia setting does not update

Check that the corresponding `home/noctalia/*.toml` file is linked and valid for the installed Noctalia version. Inspect Noctalia's GUI and `~/.local/state/noctalia/settings.toml` before removing state. Back up any customized values first.

### A desktop selection fails

Confirm that `settings.nix` uses a matching file name under `modules/desktops/`. Also check that the chosen desktop's display manager, session type and input method are configured consistently. The presence of a `.nix` file is not a guarantee that every desktop profile is equally tested.

### A package is unfree or unavailable

`modules/core/nix.nix` enables `nixpkgs.config.allowUnfree = true`, and Home Manager shares the global package set. Package names may change between Nixpkgs releases; search the NixOS package index and upstream package documentation.

### A new computer has no working display or boot

Review the machine-specific hardware file, CPU module, bootloader configuration, EFI setup and monitor configuration. Do not reuse the archive's disk UUIDs or assume that the original laptop's hardware settings apply. Use a known-good NixOS generation or recovery media if necessary.

### Roll back a bad switch

If the previous generation is still available, use the boot menu to start it. From a working generation, diagnose the configuration and rebuild before switching again. Do not remove old generations until the new setup has been tested.

## 🙏 Credits and acknowledgements

This configuration builds on the work of many open-source projects. Thank you to the maintainers and contributors who make a reproducible, customizable Linux desktop possible.

- **NixOS / Nix team and community** — for Nix, Nixpkgs, NixOS and the ecosystem behind declarative system configuration: [github.com/NixOS](https://github.com/NixOS).
- **Home Manager contributors** — for declarative user environments and dotfile management: [nix-community/home-manager](https://github.com/nix-community/home-manager).
- **CachyOS** — for the Niri + Noctalia configuration and guidance that helped inform this setup: [CachyOS/cachyos-niri-noctalia](https://github.com/CachyOS/cachyos-niri-noctalia).
- **Niri developers and contributors** — for the scrollable tiling Wayland compositor: [niri-wm/niri](https://github.com/niri-wm/niri).
- **Noctalia developers and contributors** — for the desktop shell and its configuration ecosystem: [noctalia-dev/noctalia](https://github.com/noctalia-dev/noctalia).
- **DenverCoder1** — for the [Minimalistic Wallpaper Collection](https://github.com/DenverCoder1/minimalistic-wallpaper-collection). Please also respect the collection's own attribution notes and the original artists' rights; the repository notes that it does not claim ownership of every wallpaper it collects.
- **Starship contributors** — for the cross-shell prompt: [starship/starship](https://github.com/starship/starship).
- **Fastfetch contributors** — for the system-information tool: [fastfetch-cli/fastfetch](https://github.com/fastfetch-cli/fastfetch).
- **Alacritty contributors** — for the GPU-accelerated terminal emulator: [alacritty/alacritty](https://github.com/alacritty/alacritty).
- **The wider ecosystem** — including GNOME, KDE, COSMIC, XFCE, Budgie, Cinnamon, PipeWire, Fcitx5, IBus, Git, bat, Neovim, Firefox, and all the other projects referenced above.

This project is an independent configuration, not an official NixOS, CachyOS, Niri or Noctalia release. Please consult each upstream project's repository for its license, contribution guidelines and attribution requirements. The license of this configuration does not override the licenses of its dependencies, themes, fonts, wallpapers or other assets.

---

<div align="center">

**Made to be explored, understood, and customized.**  
If this configuration helps you, feel free to fork it, adapt it, and make it your own.

</div>
