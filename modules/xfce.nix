{ pkgs, ... }:
{
  # XFCE runs on X11
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

  # Network tray icon (NetworkManager is enabled in networking.nix)
  programs.nm-applet.enable = true;

  # Nepali input (IBus)
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ];
  };
}
