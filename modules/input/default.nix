# System-level input method. Only ibus lives here (it must be started by the
# system session, not by Home Manager). fcitx5 is configured in home/input/.
# (Plain import: `imports` is resolved before module arguments exist.)
let
  settings = import ../../settings.nix;
in
{
  imports = if settings.inputMethod == "ibus" then [ ./ibus.nix ] else [ ];
}
