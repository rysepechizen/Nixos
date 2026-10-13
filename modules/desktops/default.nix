# Picks the desktop named by `desktop` in settings.nix.
# (A plain import, not the `settings` argument: `imports` is resolved before
#  module arguments exist.)
let
  settings = import ../../settings.nix;
in
{
  imports = [
    ./common.nix
    ./${settings.desktop}.nix
  ];
}
