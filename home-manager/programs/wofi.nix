{ config, pkgs, lib, ... }:

{
  xdg.desktopEntries.awakened-poe-trade = {
    name = "Awakened PoE Trade";
    exec = "env XDG_SESSION_TYPE=x11 /run/current-system/sw/bin/appimage-run ${config.home.homeDirectory}/Games/Awakened-PoE-Trade-3.28.103.AppImage";
    terminal = false;
    categories = [ "Game" ];
  };

  # xdg.desktopEntries.obsidian = {
  #   name = "Obsidian";
  #   exec = "env XDG_SESSION_TYPE=x11 /run/current-system/sw/bin/appimage-run ${config.home.homeDirectory}/Documents/Obsidian-1.12.7.AppImage";
  #   terminal = false;
  #   categories = [ "Utility" ];
  # };

  programs.wofi = {
    enable = true;

    settings = {
      gtk-dark = true;
      show = "drun";
      width = 900;
      height = 600;
      always_parse_args = true;
      show_all = false;
      print_command = true;
    };

    style = ''
      /* Catppuccin Mocha */
      * {
        font-family: "Fira Code", monospace;
        font-size: 21px;
        background-color: transparent;
        color: #cdd6f4;
      }

      window {
        background-color: #1e1e2e;
        border: 2px solid #cba6f7;
        margin: 0px;
        border-radius: 12px;
        overflow: hidden;
      }

      #input {
        background-color: #313244;
        color: #cdd6f4;
        border: none;
        border-radius: 8px;
        margin: 12px;
        padding: 12px 16px;
        font-size: 31px;
      }

      #input placeholder {
        color: #6c7086;
      }

      #inner-box {
        margin: 8px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 8px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0 4px;
      }

      #entry {
        border-radius: 8px;
        padding: 6px 10px;
        margin: 2px 0;
      }

      #entry:selected {
        background-color: #313244;
        color: #cba6f7;
      }

      #entry:selected #text {
        color: #cba6f7;
      }

      #text {
        margin: 2px;
        color: #cdd6f4;
      }

      #img {
        margin-right: 8px;
      }
    '';
  };
}
  
