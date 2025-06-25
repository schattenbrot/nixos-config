{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/base.lua}
      ${builtins.readFile ./nvim/highlights.lua}
      ${builtins.readFile ./nvim/maps.lua}
    '';
  };
}
