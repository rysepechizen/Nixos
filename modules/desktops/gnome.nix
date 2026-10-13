{ pkgs, lib, settings, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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

  # Login-screen cursor: GDM can't see your Home Manager packages
  environment.systemPackages = [ pkgs.${settings.cursor.package} ];
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        cursor-theme = settings.cursor.name;
        cursor-size = lib.gvariant.mkUint32 settings.cursor.size;
      };
    }
  ];
}
