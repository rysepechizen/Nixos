# Battery, power profiles and Bluetooth. Used by shell widgets (Noctalia, GNOME, KDE…).
{ ... }:
{
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
}
