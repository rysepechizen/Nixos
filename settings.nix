# ════════════════════════════════════════════════════════════════
#  settings.nix — the one file you edit per machine / per distro
# ════════════════════════════════════════════════════════════════
# Both halves of the config read this:
#   modules/**  NixOS (system)         gets it as the `settings` argument
#   home/**     Home Manager (you)     gets it as the `settings` argument
# Change a value here and system + home follow together.
let
  # "niri" | "kde" | "cosmic" | "gnome" | "xfce" | "budgie" | "cinnamon"
  desktop = "kde";

  # Desktops that only run on X11. Everything else is a Wayland session.
  x11Desktops = [ "xfce" "budgie" "cinnamon" ];
in
{
  inherit desktop;

  hostName = "Latitude-5410";
  timeZone = "Asia/Kathmandu";
  locale = "en_US.UTF-8";

  # Do not change after install, even when upgrading NixOS / Home Manager.
  stateVersion = "26.05";

  user = {
    name = "sanzay";
    description = "Nixos";
  };

  # ── Input method (configured in home/input/) ──────────────────
  # XFCE uses ibus (started by the SYSTEM, modules/input/ibus.nix);
  # every other desktop uses fcitx5 (Home Manager, home/input/fcitx5.nix).
  inputMethod = if builtins.elem desktop [ "xfce" "gnome" ] then "ibus" else "fcitx5";
  # fcitx5 talks to Wayland natively unless the session is X11.
  isX11 = builtins.elem desktop x11Desktops;

  # ── Cursor (login screen, niri session, GNOME) ────────────────
  cursor = {
    name = "Bibata-Modern-Ice";
    package = "bibata-cursors"; # attribute name inside pkgs
    size = 24;
  };
}
