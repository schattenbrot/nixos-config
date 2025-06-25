{ pkgs, ... }:

{
	programs.waybar = {
		enable = true;

		settings = {
			mainBar = {
				height = 20;
				layer = "top";
				modules-left = [ "hyprland/workspaces" ];
				modules-center = [ "clock" ];
				modules-right = [ "cpu" "memory" "pulseaudio" "tray" "hyprland/language" ];

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

					"hyprland/language" = {
						format = "{short}";
					};

					"tray" = {
						spacing = 10;
					};

					"clock" = {
						format = "{:%H:%M}";
						format-alt = "{:%b %d %Y}";
						tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					};

					"cpu" = {
            interval = 10;
            format = " CPU: {}%";
            max-length = 10;
					};

          "memory" = {
            interval = 30;
            format = " Memory: {}%";
            format-alt = " {used:0.1f}GB";
            max-length = 10;
          };

          "network" = {
            format-wifi = "<small>{bandwidthDownBytes}</small> {icon}";
            min-length = 10;
            fixed-width = 10;
            format-ethernet = "󰈀";
            format-disconnected = "󰤭";
            tooltip-format = "{essid}";
            interval = 1;
            on-click = "~/.config/waybar/scripts/network/rofi-network-manager.sh";
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          };

          "pulseaudio" = {
            format = "{icon}";
            format-muted = "󰖁";
            format-icons = {
              default = ["" "" "󰕾"];
            };
            on-click = "pamixer -t";
            on-scroll-up = "pamixer -i 1";
            on-scroll-down = "pamixer -d 1";
            on-click-right = "exec pavucontrol";
            tooltip-format = "Volume {volume}%";
          };

          "custom/spotify" = {
            #exec = "nix-shell ~/.config/waybar/scripts/mediaplayer.py --player youtube-music";
						exec = "/usr/bin/python3 ~/.config/waybar/scripts/mediaplayer.py --player spotify";
            format = " {}";
            return-type = "json";
            on-click = "playerctl play-pause";
            on-double-click-right = "playerctl next";
            on-scroll-down = "playerctl previous";
          };
				};

			};
			style = ''
			 * {
					/* otf-font-awesome is required to be installed for icons */
				font-family: 'Fira Code', Material Design Icons, JetBrainsMono Nerd Font, Iosevka Nerd Font;
				font-size: 14px;
				border: none;
					border-radius: 0;
					min-height: 0;
				}
			'';
		};
}
