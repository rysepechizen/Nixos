{ ... }:
{
  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";

      # Test the system configuration without switching.
      rebuild-check = "sudo nixos-rebuild dry-build --flake /etc/nixos#Latitude-5410";

      # Apply the system and Home Manager configuration.
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#Latitude-5410";
    };

    initExtra = ''
      fastfetch
    '';
  };

  programs.bat.enable = true;
}
