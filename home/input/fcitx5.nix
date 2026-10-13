# fcitx5 — Wayland desktops (niri, KDE, GNOME, COSMIC…). Nepali via m17n.
{ pkgs, settings, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      # Native Wayland text-input. Off only on X11 sessions.
      waylandFrontend = !settings.isX11;

      addons = with pkgs; [
        fcitx5-m17n
        fcitx5-gtk
        kdePackages.fcitx5-configtool
      ];

      settings.globalOptions = {
        # Not Super+space: niri binds Mod+Space to the Noctalia launcher,
        # so fcitx5 would never see it.
        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
          "1" = "Alt+Shift_L";
        };
        "Hotkey/EnumerateGroupForwardKeys" = {
          "0" = "Control+Super+space";
        };
      };

      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "m17n_ne_trad-ttf";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "m17n_ne_trad-ttf";
          Layout = "";
        };
      };
    };
  };

  # Keep fcitx5's own launchers out of the app menu.
  xdg.desktopEntries = {
    "org.fcitx.Fcitx5" = {
      name = "Fcitx 5";
      exec = "fcitx5";
      noDisplay = true;
    };
    "org.fcitx.fcitx5-config-qt" = {
      name = "Fcitx 5 Configuration";
      exec = "fcitx5-config-qt";
      noDisplay = true;
    };
    "org.fcitx.fcitx5-migrator" = {
      name = "Fcitx 5 Migration Wizard";
      exec = "fcitx5-migrator";
      noDisplay = true;
    };
  };
}
