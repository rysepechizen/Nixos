# ibus — XFCE (X11). Nepali via m17n.
{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ];
  };

  # Optional: preload engines declaratively. Get exact names from `ibus list-engine`.
  # dconf.settings."desktop/ibus/general".preload-engines = [ "xkb:us::eng" "m17n:ne:trad" ];
}
