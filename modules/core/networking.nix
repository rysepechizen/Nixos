{ settings, ... }:
{
  networking.hostName = settings.hostName;
  networking.networkmanager.enable = true;
}
