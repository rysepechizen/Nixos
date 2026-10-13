{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      # One command now applies the system AND your home config.
      rebuild = "sudo nixos-rebuild switch";
    };
    initExtra = ''
      fastfetch
    '';
  };

  programs.bat.enable = true;
}
