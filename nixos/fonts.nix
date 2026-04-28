{ config, pkgs, lib, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
    font-awesome
    roboto
    fira-code
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto Slab" ];
	      monospace = [ "Fira Code" ];
      };
    };
  };
}
