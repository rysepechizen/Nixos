{ pkgs, ... }:
{
  # Cinnamon runs on X11
  services.xserver = {
    enable = true;
  };

  # Desktop Environment
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Mouse scrolling issue fixed for Firefox
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = 1;
  };

  # Nepali input (IBus)
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      m17n
    ];
  };

  # Cinnamon-specific configuration
  systemd.user.services.cinnamon-settings = {
    description = "Cinnamon desktop settings";
    wantedBy = [ "cinnamon-session.target" ];
    after = [ "cinnamon-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.glib}/bin/gsettings set org.cinnamon enabled-applets \
        "['panel1:left:0:menu@cinnamon.org:0', \
        'panel1:left:1:separator@cinnamon.org:1', \
        'panel1:left:2:grouped-window-list@cinnamon.org:2', \
        'panel1:right:0:systray@cinnamon.org:3', \
        'panel1:right:1:xapp-status@cinnamon.org:4', \
        'panel1:right:2:notifications@cinnamon.org:5', \
        'panel1:right:3:printers@cinnamon.org:6', \
        'panel1:right:4:removable-drives@cinnamon.org:7', \
        'panel1:right:5:favorites@cinnamon.org:9', \
        'panel1:right:6:network@cinnamon.org:10', \
        'panel1:right:7:sound@cinnamon.org:11', \
        'panel1:right:8:power@cinnamon.org:12', \
        'panel1:right:9:calendar@cinnamon.org:13', \
        'panel1:right:10:cornerbar@cinnamon.org:14']"
    '';
  };
}
