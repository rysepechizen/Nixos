# XFCE runs on X11. Its input method (ibus) is set up in home/input/ibus.nix.
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };
  };

  services.displayManager.defaultSession = "xfce";

  # XFCE debloat
  environment.xfce.excludePackages = with pkgs; [
    mousepad
    parole
    # ristretto
    # xfce4-screenshooter
    # xfce4-taskmanager
  ];

  # Network tray icon (NetworkManager is enabled in core/networking.nix)
  programs.nm-applet.enable = true;
}
