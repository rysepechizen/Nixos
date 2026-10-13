{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;

    input.touchpads = [
      {
        name = "DELL09A0:00 0488:120A Touchpad";
        naturalScroll = false;
      }
    ];
  };

  systemd.user.services.kde-display-scale = {
    Unit = {
      Description = "Set KDE display scaling to 125 percent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.eDP-1.scale.1.25";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}

