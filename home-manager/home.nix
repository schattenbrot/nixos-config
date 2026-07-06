{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = [
    programs/fish.nix
    programs/git.nix
    programs/kitty.nix
    programs/neovim/default.nix
    programs/obsidian.nix
		programs/vscode/default.nix
    programs/wofi.nix
    services/mako.nix
    services/zoxide.nix
    wm/hyprland.nix
    wm/niri.nix
  ];

  home = {
    stateVersion = "25.05";

    file.".local/bin/pkhex" = {
      source = ./scripts/pkhex.sh;
      executable = true;
    };

    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = with pkgs; [
      # File Managers
      ranger
      unzip
      xclip

      # Web browsers
      firefox
      brave

      # Entertainment
      discord
      spotify

      # System
      htop
      direnv
      grc
      hyprpaper
      awww
      python3

      # Screenshot and cature
      grim
      slurp

      # Audio
      pavucontrol
      alsa-utils

      # Gaming
      lutris

      snixembed
    ];
  };
}
