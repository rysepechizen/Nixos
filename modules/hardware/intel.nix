# Intel CPU (Latitude 5410). On an AMD machine, swap this file for an amd.nix
# with hardware.cpu.amd.updateMicrocode = true; and drop thermald.
{ ... }:
{
  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
}
