# Login screen: greetd running the Noctalia greeter.
{ pkgs, pkgs-unstable, settings, ... }:
let
  cursorPackage = pkgs.${settings.cursor.package};
  toml = pkgs.formats.toml { };
in
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = "${pkgs-unstable.noctalia-greeter}/bin/noctalia-greeter-session";
    };
  };

  # Puts the `noctalia-greeter sessions/outputs` helpers on PATH.
  environment.systemPackages = [ pkgs-unstable.noctalia-greeter ];

  # The greeter keeps greeter.toml, sync.toml and wallpapers here, owned by the
  # greetd session user.
  systemd.tmpfiles.rules = [
    "d /var/lib/noctalia-greeter 0750 greeter greeter -"
  ];

  # Cursor on the login screen (same theme as the session).
  systemd.tmpfiles.settings."10-noctalia-greeter-toml"."/var/lib/noctalia-greeter/greeter.toml"."L+" = {
    argument = toString (
      toml.generate "greeter.toml" {
        cursor = {
          theme = settings.cursor.name;
          size = settings.cursor.size;
          path = "${cursorPackage}/share/icons";
        };
      }
    );
  };

  # Greeter wallpaper/palette sync without a password prompt. The rule only
  # covers Noctalia's one helper binary, for your user, in a local active session.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var allowedUsers = ${builtins.toJSON [ settings.user.name ]};
      if (action.id == "org.noctalia.greeter.sync-appearance" &&
          action.lookup("program") == "${pkgs-unstable.noctalia-greeter}/bin/noctalia-greeter-apply-appearance" &&
          action.lookup("user") == "root" &&
          subject.local && subject.active &&
          allowedUsers.indexOf(subject.user) >= 0) {
        return polkit.Result.YES;
      }
    });
  '';
}
