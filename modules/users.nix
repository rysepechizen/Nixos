{ pkgs, ... }:
{
  users.users."sanzay" = {
    isNormalUser = true;
    description = "Nixos";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

