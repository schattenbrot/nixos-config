{ pkgs, ... }:

{
  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };

  services.udev.packages = [
    pkgs.streamdeck-ui
  ];
}