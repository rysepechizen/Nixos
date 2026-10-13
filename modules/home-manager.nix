
{ settings, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users.${settings.user.name} = import ../home;
  };
}
