{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        yzhang.markdown-all-in-one
        golang.go
        esbenp.prettier-vscode
        vscodevim.vim
      ];
    };
  };

  # Tell VSCode to store its settings in your repo
  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink ./settings.json;
}
