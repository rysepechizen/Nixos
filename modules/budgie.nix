{ pkgs, ... }:
{
  # LightDM needs X11
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.desktopManager.budgie.enable = true;
  services.displayManager.defaultSession = "budgie-desktop";
  
  # Budgie debloat (the wiki's example; uncomment to use)
  # environment.budgie.excludePackages = with pkgs; [
  #   mate.mate-terminal
  #   vlc
  # ];

  # Nepali input (IBus)
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ];
  };
}
