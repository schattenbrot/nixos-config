{ config, pkgs, ... }:

{
  programs.eza.enable = true;
  programs.fish = {
    enable = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";

      ls = "eza --long --git --icons";
      ll = "eza --long --git -a --icons";
      df = "df -H";

      g = "git";
      v = "vim";
    };

    functions = {
      pyon = "echo \"usa usa pyon pyon uwu nya~ <3\"";
    };

    interactiveShellInit = ''
      set fish_greeting
      setenv EDITOR vim
      setenv VISUAL vim
    '';

    plugins = [
      { name = "direnv"; src = pkgs.direnv; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
  };
}
