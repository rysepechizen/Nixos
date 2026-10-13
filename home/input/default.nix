# Home Manager input method: fcitx5 only (every desktop except XFCE).
# ibus is started by the system — see modules/input/ibus.nix.
# (Plain import: `imports` is resolved before module arguments exist.)
let
  settings = import ../../settings.nix;
in
{
  imports = if settings.inputMethod == "fcitx5" then [ ./fcitx5.nix ] else [ ];
}
