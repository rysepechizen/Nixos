{ settings, ... }:
{
  users.users.${settings.user.name} = {
    isNormalUser = true;
    description = settings.user.description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
