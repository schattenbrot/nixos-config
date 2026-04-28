{ config, pkgs, lib, ... }:
let
  terminal = "kitty";
  graphicalFileManager = "dolphin";
  browser = "firefox";
  menu = "wofi --gtk-dark --show drun";
  passwordManager = "1password";

in
{
  imports = [
    ../programs/waybar/waybar.nix
    ../services/hyprpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

			monitor = [
				"DP-1, 3840x2160@240.00, 0x0, 1"
				"DP-2, 2560x1440@165.00, 3840x0, 1"
			];

			env = [
        "XCURSOR_THEME,capitaine-cursors"
        "XCURSOR_SIZE,32"
      ];

			windowrulev2 = [
				"workspace special:spotify silent, class:^(Spotify)$"
				"workspace special:1password silent, class:^(1Password)$ title:^(?!.*Quick Access).*$"
				"workspace 9 silent, class:^(discord)$"
        "noblur, class:^(awakened-poe-trade)$"
			];

      layerrule = [
        "ignorezero, wofi"
        "ignorealpha 0.5, wofi"
      ];

      exec-once = [
			  "dbus-update-activation-environment --systemd --all"
				"sleep 3 && ${config.home.homeDirectory}/nixos-config/home-manager/scripts/set-audio.sh"
				"waybar"
				"spotify"
				"discord"
				"blueman-applet"
        "[workspace 1 silent] ${terminal}"
				"[workspace 2 silent] ${browser}"
				"${passwordManager}"
      ];

      general = {
        gaps_in = 5;
				gaps_out = 5;

				border_size = 2;

				"col.active_border" = "rgba(ffeeffee) rgba(ffbbffee) 45deg";
				"col.inactive_border" = "rgba(595959aa)";

				resize_on_border = false;

				allow_tearing = false;

				layout = "master";
      };

      decoration = {
        rounding = 10;
				rounding_power = 2;

				active_opacity = 1.0;
				inactive_opacity = 1.0;

				shadow = {
					enabled = true;
					range = 4;
					render_power = 3;
					color = "rgba(1a1a1aee)";
				};

				blur = {
					enabled = true;
					size = 3;
					passes = 1;
					vibrancy = 0.1696;
				};
      };

      animations = {
        enabled = "yes, please :)";
    
        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

				bezier = [
					"easeOutQuint,0.23,1,0.32,1"
					"easeInOutCubic,0.65,0.05,0.36,1"
					"linear,0,0,1,1"
					"almostLinear,0.5,0.5,0.75,1.0"
					"quick,0.15,0,0.1,1"
				];

				animation = [
					"global, 1, 10, default"
					"border, 1, 5.39, easeOutQuint"
					"windows, 1, 4.79, easeOutQuint"
					"windowsIn, 1, 4.1, easeOutQuint, popin 87%"
					"windowsOut, 1, 1.49, linear, popin 87%"
					"fadeIn, 1, 1.73, almostLinear"
					"fadeOut, 1, 1.46, almostLinear"
					"fade, 1, 3.03, quick"
					"layers, 1, 3.81, easeOutQuint"
					"layersIn, 1, 4, easeOutQuint, fade"
					"layersOut, 1, 1.5, linear, fade"
					"fadeLayersIn, 1, 1.79, almostLinear"
					"fadeLayersOut, 1, 1.39, almostLinear"
					"workspaces, 1, 1.94, almostLinear, fade"
					"workspacesIn, 1, 1.21, almostLinear, fade"
					"workspacesOut, 1, 1.94, almostLinear, fade"
				];
      };

      master = {
        mfact = 0.50;
				new_status = "inherit";
        new_on_active = "after";
      };

      misc = {
        force_default_wallpaper = 0;
				disable_hyprland_logo = false;
      };

			input = {
				kb_layout = "eu";
				kb_variant = "";
				kb_model = "";
				kb_options = "";
				kb_rules = "";
				follow_mouse = 2;

				sensitivity = 0;
			};


			bind = [
				# General
				"$mod, return, exec, ${terminal}"
				"$mod, Q, exec, ${terminal}"
				"$mod SHIFT, C, killactive"
				"$mod, E, exec, ${graphicalFileManager}"
				"$mod, V, togglefloating"
				"$mod, D, exec, ${menu}"
				"$mod, W, exec, ${browser}"
				"$mod, P, exec, kitty steam"
				"$mod, space, fullscreen, 0"
				"$mod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
				"SHIFT CTRL, space, exec, 1password --quick-access"

        # Monitors
				"$mod, M, focusmonitor, l"
				"$mod SHIFT, M, focusmonitor, r"

				# Move focus / window
				"$mod, J, layoutmsg, cyclenext"
				"$mod, K, layoutmsg, cycleprev"
				"$mod SHIFT, J, layoutmsg, swapnext"
				"$mod SHIFT, K, layoutmsg, swapprev"

				# Move special workspace (scratchpad)
				"$mod, L, togglespecialworkspace, 1password"
				"$mod SHIFT, L, movetoworkspacesilent, special:1password"
				"$mod, U, togglespecialworkspace, quickshell"
				"$mod SHIFT, U, movetoworkspacesilent, special:quickshell"
				"$mod, Y, togglespecialworkspace, spotify"
				"$mod SHIFT, Y, movetoworkspacesilent, special:spotify"
			]

			# Switch/moveto workspaces
			++ (
				# bind $mod + [shift +] {1..10} to [move to] workspace {1..10}
				builtins.concatLists (builtins.genList (
					x: let
						ws = let
							c = (x + 1) / 10;
						in
							builtins.toString(x + 1 - (c * 10));
					in [
						"$mod, ${ws}, focusworkspaceoncurrentmonitor, ${toString(x + 1)}"
						"$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString(x + 1)}"
					]
				)
				10)
			);

			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];
		};

		package = null;
		portalPackage = null;
  };
}
