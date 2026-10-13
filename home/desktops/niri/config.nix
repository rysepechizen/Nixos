# Installs the niri KDL tree (config.kdl + cfg/*.kdl) into ~/.config/niri.
#
# Why per-file links and not one linked directory: Noctalia generates
# ~/.config/niri/noctalia.kdl (theme colours) at runtime, so that directory
# must stay writable. Our files are read-only store links; Noctalia's file is
# a normal file next to them.
{ config, lib, pkgs, ... }:
let
  # Fail `nixos-rebuild` on a broken niri config instead of at login.
  validate = true;

  niriDir = "${config.xdg.configHome}/niri";

  niriConfig = pkgs.runCommand "niri-config" { nativeBuildInputs = [ pkgs.niri ]; } ''
    mkdir -p $out
    cp --no-preserve=mode ${./config.kdl} $out/config.kdl
    cp -r --no-preserve=mode ${./cfg} $out/cfg

    ${lib.optionalString validate ''
      # Check a scratch copy that has a stand-in for the colours file
      # Noctalia generates at runtime.
      tmp=$(mktemp -d)
      cp -r $out/. $tmp/
      : > $tmp/noctalia.kdl
      niri validate -c $tmp/config.kdl
    ''}

    # If niri resolves includes relative to the real (store) path rather than
    # the ~/.config symlink, this keeps `include "./noctalia.kdl"` working.
    ln -s ${niriDir}/noctalia.kdl $out/noctalia.kdl
  '';
in
{
  xdg.configFile."niri/config.kdl".source = "${niriConfig}/config.kdl";
  xdg.configFile."niri/cfg" = {
    source = "${niriConfig}/cfg";
    recursive = true;
  };

  # config.kdl includes ./noctalia.kdl. Until Noctalia has generated it (first
  # login), an empty file keeps niri from refusing to load the config.
  home.activation.niriNoctaliaStub = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stub="${niriDir}/noctalia.kdl"
    if [ ! -e "$stub" ]; then
      run mkdir -p "${niriDir}"
      run touch "$stub"
    fi
  '';
}
