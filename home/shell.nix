{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      rebuild = "sudo nixos-rebuild switch";
    };
    initExtra = ''
      fastfetch
    '';
  };

  programs.starship.enable = true;
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.bat.enable = true;
}
