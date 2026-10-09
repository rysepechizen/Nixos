{ pkgs, ... }:

let
  mac-style-src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "s4rchiso-plymouth-theme";
    rev = "bc585b7f42af415fe40bece8192d9828039e6e20";
    sha256 = "sha256-yOvZ4F5ERPfnSlI/Scf9UwzvoRwGMqZlrHkBIB3Dm/w=";
  };

  mac-style-plymouth = pkgs.callPackage mac-style-src {};
in
{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 4;
    style = {
    wallpapers =[];
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [ mac-style-plymouth ];
  };

  # Silent boot
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
  ];

  boot.consoleLogLevel = 0;
}
