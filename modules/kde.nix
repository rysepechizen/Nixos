{ pkgs, ... }:
{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    drkonqi
    kinfocenter
    khelpcenter
  ];

  # Nepali / Devanagari input (fcitx5)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ fcitx5-m17n ];

      # Use only the config declared here, not ~/.config/fcitx5
      ignoreUserConfig = true;

      settings.globalOptions = {
        "Hotkey/TriggerKeys" = {
          "0" = "Super+space";
          "1" = "Control+space";
        };
        "Hotkey/EnumerateGroupForwardKeys" = {
          "0" = "Control+Super+space";
        };
      };

      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "m17n_ne_trad-ttf";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "m17n_ne_trad-ttf";
          Layout = "";
        };
      };
    };
  };
}
