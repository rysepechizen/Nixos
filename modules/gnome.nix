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
    gnomeExtensions.app-hider
    orchis-theme
    tela-icon-theme
    bibata-cursors
  ];

  services.gnome.games.enable = false;
  services.gnome.core-developer-tools.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    yelp
    epiphany
    geary
    gnome-contacts
    gnome-maps
    gnome-logs
    decibels
    totem
    gnome-connections
    gnome-characters
    baobab
  ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ];
  };

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        cursor-theme = "Bibata-Modern-Ice";
        cursor-size = lib.gvariant.mkUint32 24;
      };
    }
  ];

  programs.dconf.profiles.user.databases = [
    {
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
            pkgs.gnomeExtensions.app-hider.extensionUuid
          ];
        };

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

        "org/gnome/desktop/peripherals/touchpad" = {
          send-events = "disabled-on-external-mouse";
        };
      };
    }
  ];
}
