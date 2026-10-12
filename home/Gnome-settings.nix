{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ orchis-theme tela-icon-theme bibata-cursors ];

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = caffeine; }
    ];
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      always-show-log-out = true;
    };

    "org/gnome/desktop/interface" = {
      font-name = "Inter 12";
      document-font-name = "Inter 12";
      monospace-font-name = "JetBrainsMono Nerd Font 12";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = lib.hm.gvariant.mkUint32 24;
    };

    "org/gnome/desktop/wm/preferences".titlebar-font = "Inter Bold 12";

    "org/gnome/desktop/peripherals/touchpad".send-events = "disabled-on-external-mouse";
  };

  # Switch GTK, icon and shell themes with GNOME's dark/light preference
  systemd.user.services.theme-follow-color-scheme = {
    Unit = {
      Description = "Switch GTK/shell/icon themes with GNOME dark/light";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = toString (pkgs.writeShellScript "theme-follow" ''
        dconf=${pkgs.dconf}/bin/dconf
        apply() {
          case "$($dconf read /org/gnome/desktop/interface/color-scheme)" in
            *dark*) gtk=Orchis-Dark; shell=Orchis-Dark; icons=Tela-dark ;;
            *)      gtk=Orchis-Light; shell=Orchis-Light; icons=Tela ;;
          esac
          $dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk'"
          $dconf write /org/gnome/desktop/interface/icon-theme "'$icons'"
          $dconf write /org/gnome/shell/extensions/user-theme/name "'$shell'"
        }
        apply
        $dconf watch /org/gnome/desktop/interface/color-scheme |
          while read -r _; do apply; done
      '');
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
