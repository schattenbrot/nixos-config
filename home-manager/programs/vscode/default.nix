{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
				github.copilot
        golang.go
        vscodevim.vim
        yzhang.markdown-all-in-one
      ];
    };
  };

  # Tell VSCode to store its settings in your repo
  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink ./settings.json;
}
