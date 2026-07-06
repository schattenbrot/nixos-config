{ config, pkgs, lib, ... }:
let
  terminal = "kitty";
  graphicalFileManager = "dolphin";
  browser = "firefox";
  menu = "env DRI_PRIME=1 wofi --gtk-dark --show drun";
  passwordManager = "1password";
  wallpaper = "/home/ellychan/Documents/Images/neko_ruby.png";
in
{
  # niri reads ~/.config/niri/config.kdl. Written as raw KDL so no extra
  # home-manager module (niri-flake) is required. The niri package/session
  # itself is enabled system-wide via programs.niri.enable in configuration.nix.
  xdg.configFile."niri/config.kdl".text = ''
    environment {
        XCURSOR_THEME "capitaine-cursors"
        XCURSOR_SIZE "64"
    }

    output "DP-1" {
        mode "3840x2160@240.000"
        position x=0 y=0
        scale 1.0
    }

    output "DP-2" {
        mode "2560x1440@165.000"
        position x=3840 y=0
        scale 1.0
    }

    input {
        keyboard {
            xkb {
                layout "eu"
            }
        }
        mouse {
            accel-speed 0.0
        }
        warp-mouse-to-focus
    }

    layout {
        gaps 5
        preset-column-widths {
            proportion 0.5
            proportion 1.0
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            off
        }
        border {
            width 2
            active-gradient from="#ffeeff" to="#ffbbff" angle=45
            inactive-color "#595959"
        }
    }

    prefer-no-csd

    workspace "main" {
        open-on-output "DP-1"
    }
    workspace "browser" {
        open-on-output "DP-1"
    }
    workspace "sec" {
        open-on-output "DP-1"
    }
    workspace "discord" {
        open-on-output "DP-2"
    }
    workspace "obsidian"
    workspace "spotify"

    spawn-at-startup "dbus-update-activation-environment" "--systemd" "--all"
    spawn-at-startup "sh" "-c" "awww-daemon & sleep 0.5 && awww img ${wallpaper} --resize fit --transition-type none"
    spawn-at-startup "waybar"
    spawn-at-startup "spotify"
    spawn-at-startup "discord"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "${terminal}"
    spawn-at-startup "${browser}"
    spawn-at-startup "${passwordManager}"

    {
        match at-startup=true
        open-on-output "DP-1"
    }

    window-rule {
        match app-id="^Spotify$"
        open-on-workspace "spotify"
    }

    window-rule {
        match app-id="^discord$"
        open-on-workspace "discord"
    }

    window-rule {
        match app-id="^obsidian$"
        open-on-workspace "obsidian"
    }

    binds {
        // General
        Mod+Return { spawn "${terminal}"; }
        Mod+Q      { spawn "${terminal}"; }
        Mod+Shift+C { close-window; }
        Mod+E { spawn "${graphicalFileManager}"; }
        Mod+V { toggle-window-floating; }
        Mod+D { spawn "sh" "-c" "${menu}"; }
        Mod+W { spawn "${browser}"; }
        Mod+P { spawn "kitty" "steam"; }
        Mod+Shift+S { spawn "sh" "-c" "grim -g \"$(slurp -d)\" - | wl-copy"; }
        Ctrl+Shift+Space { spawn "1password" "--quick-access"; }

        // Window size
        Mod+Shift+Space { fullscreen-window; }
        Mod+Space { maximize-column; }

        // Move focus / window between columns
        Mod+J { focus-column-right-or-first; }
        Mod+K { focus-column-left-or-last; }
        Mod+Shift+J { move-column-right; }
        Mod+Shift+K { move-column-left; }
        Mod+Shift+Ctrl+J { move-column-to-last; }
        Mod+Shift+Ctrl+K { move-column-to-first; }

        // Monitors (only 2 — one key cycles to the other)
        Mod+M { focus-monitor-next; }
        Mod+Shift+M { move-workspace-to-monitor-next; }

        // Fixed workspace anchors — always the same key, no matter what else is open.
        Mod+1 { focus-workspace "main"; }
        Mod+2 { focus-workspace "browser"; }
        Mod+3 { focus-workspace "sec"; }
        Mod+7 { focus-workspace "obsidian"; }
        Mod+8 { focus-workspace "spotify"; }
        Mod+9 { focus-workspace "discord"; }

        // Move window to fixed workspace anchors
        Mod+Shift+1 { move-window-to-workspace "main"; }
        Mod+Shift+2 { move-window-to-workspace "browser"; }
        Mod+Shift+3 { move-window-to-workspace "sec"; }
        Mod+Shift+7 { move-window-to-workspace "obsidian"; }
        Mod+Shift+8 { move-window-to-workspace "spotify"; }
        Mod+Shift+9 { move-window-to-workspace "discord"; }

        // Step through whatever else is on the focused monitor.
        Mod+H { focus-workspace-up; }
        Mod+L { focus-workspace-down; }
        Mod+Shift+H { move-workspace-up; }
        Mod+Shift+L { move-workspace-down; }
    }
  '';
}
