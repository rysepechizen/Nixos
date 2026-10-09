{ ... }:
{
  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # in MB, so this is 8 GB
    }
  ];
}
