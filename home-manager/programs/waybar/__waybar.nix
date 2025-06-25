{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        "hyprland/workspaces" = {
					format = "{name}";
					all-outputs = true;
					on-click = "activate";
					format-icons = {
						active = " 󱎴";
						default = "󰍹";
					};
					persistent-workspaces = {
						"1" = [];
						"2" = [];
						"3" = [];
						"4" = [];
						"5" = [];
						"6" = [];
						"7" = [];
						"8" = [];
						"9" = [];
						"10" = [];
					};
				};
			};
		};
  };
}
