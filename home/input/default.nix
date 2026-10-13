# Input methods. settings.nix decides which one this machine gets:
#   xfce          → ibus.nix
#   everything else → fcitx5.nix
# (Plain import: `imports` is resolved before module arguments exist.)
let
  settings = import ../../settings.nix;
in
{
  imports = [ ./${settings.inputMethod}.nix ];
}
