{ ... }:
{
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;

  # Intel (Latitude 5410)
  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
}
