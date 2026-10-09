{ pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  environment.systemPackages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.caffeine
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.wallpaper-carousel
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    orchis-theme
    tela-icon-theme
    bibata-cursors
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  # GDM cursor
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          cursor-theme = "Bibata-Modern-Ice";
          cursor-size = lib.gvariant.mkUint32 24;
        };
      };
    }
  ];

  # GNOME declarative settings
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;

      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            pkgs.gnomeExtensions.user-themes.extensionUuid
            pkgs.gnomeExtensions.caffeine.extensionUuid
            pkgs.gnomeExtensions.app-icons-taskbar.extensionUuid
            pkgs.gnomeExtensions.wallpaper-carousel.extensionUuid
            pkgs.gnomeExtensions.appindicator.extensionUuid
  	    pkgs.gnomeExtensions.gsconnect.extensionUuid
          ];
        };

        # Locked: NixOS owns these settings
        "org/gnome/desktop/interface" = {
          font-name = "Inter 12";
          document-font-name = "Inter 12";
          monospace-font-name = "JetBrainsMono Nerd Font 12";

          cursor-theme = "Bibata-Modern-Ice";
          cursor-size = lib.gvariant.mkUint32 24;
        };

        "org/gnome/desktop/wm/preferences" = {
          titlebar-font = "Inter Bold 12";
        };
      };
    }
  ];

  # Automatically switch GTK, icon and shell themes
  # according to GNOME's dark/light preference.
  systemd.user.services.theme-follow-color-scheme = {
    description = "Switch GTK/shell/icon themes with GNOME dark/light";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = [ pkgs.dconf ];

    script = ''
      apply() {
        case "$(dconf read /org/gnome/desktop/interface/color-scheme)" in
          *dark*)
            gtk=Orchis-Dark
            shell=Orchis-Dark
            icons=Tela-dark
            ;;
          *)
            gtk=Orchis-Light
            shell=Orchis-Light
            icons=Tela
            ;;
        esac

        dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk'"
        dconf write /org/gnome/desktop/interface/icon-theme "'$icons'"
        dconf write /org/gnome/shell/extensions/user-theme/name "'$shell'"
      }

      apply

      dconf watch /org/gnome/desktop/interface/color-scheme |
        while read -r _; do
          apply
        done
    '';

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # GNOME debloat
  services.gnome.games.enable = false;
  services.gnome.core-developer-tools.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    yelp
    epiphany
    geary
    # gnome-calendar
    gnome-contacts
    gnome-maps
    # gnome-music
    # gnome-weather
    gnome-logs
    decibels
    totem
    gnome-connections
    gnome-characters
    baobab
    # gnome-system-monitor

    # Optional
    # gnome-calculator
    # snapshot
    # showtime
    # evince
  ];

  # Nepali input (IBus + m17n)
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      m17n
    ];
  };
}
