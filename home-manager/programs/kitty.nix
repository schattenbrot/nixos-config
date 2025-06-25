{ config, pkgs, user, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    font.size = 14;

    settings = {
      background_opacity = "0.85";
      background_blur = 40;
      confirm_os_window_close = 0;
      update_check_interval = 0;
    };
  };
}
