# Plumbing every desktop (and Home Manager) relies on.
{ ... }:
{
  programs.dconf.enable = true; # lets Home Manager dconf settings reach GTK apps
  services.accounts-daemon.enable = true; # user avatars on greeters
  services.gvfs.enable = true; # trash, mounts, network places in file managers
  security.polkit.enable = true;
}
