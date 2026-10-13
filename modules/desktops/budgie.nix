# Budgie runs on X11 here.
{ ... }:
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
}
