{ config, pkgs, ... }:

let
  vscodeSettings = builtins.fromJSON (builtins.readFile ./settings.json);

in
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      userSettings = vscodeSettings;
      extensions = with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        yzhang.markdown-all-in-one
        golang.go
        esbenp.prettier-vscode
        vscodevim.vim
      ];
    };
  };
}
