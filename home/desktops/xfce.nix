{ pkgs, ... }:

let
  # A deterministic wallpaper included with NixOS artwork.
  wallpaper =
    "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
in
{
  # Appearance-related packages.
  # Fonts are managed separately in fonts.nix.
  home.packages = with pkgs; [
    orchis-theme
    tela-icon-theme
    bibata-cursors
    plank
  ];

  # GTK appearance.
  gtk = {
    enable = true;

    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis-Dark";
    };

    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    font = {
      name = "Inter";
      size = 12;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # XFCE configuration.
  xfconf = {
    enable = true;

    settings = {
      xsettings = {
        "Net/ThemeName" = "Orchis-Dark";
        "Net/IconThemeName" = "Tela-dark";
        "Gtk/CursorThemeName" = "Bibata-Modern-Ice";
        "Gtk/CursorThemeSize" = 24;
        "Gtk/FontName" = "Inter 12";
      };

      # Keep the regular XFCE panel.
      xfce4-panel = {
        "panels" = [ 1 ];
      };

      # Window borders and title font.
      xfwm4 = {
        "general/theme" = "Orchis-Dark";
        "general/title_font" = "Inter Bold 12";
      };

      # Desktop wallpaper.
      xfce4-desktop = {
        "backdrop/screen0/monitor0/workspace0/color-style" = 0;
        "backdrop/screen0/monitor0/workspace0/image-style" = 5;
        "backdrop/screen0/monitor0/workspace0/last-image" = wallpaper;
      };
    };
  };

  # Launch Plank with the XFCE session.
  xdg.configFile."autostart/plank.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Plank
    Comment=Lightweight application dock
    Exec=${pkgs.plank}/bin/plank
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';
}
