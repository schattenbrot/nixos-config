# Niri workflow — fully named workspaces on Mod+1..9

A third option alongside `docs/workflow.md` (named workspaces just for Spotify/Obsidian) and `docs/workflow2.md` (dynamic workspaces for everything except Spotify/Obsidian): go all the way and declare **9 named workspaces**, one per number key, so every slot is permanent and muscle-memorized.

```
1 main       2 browser     3 sec
4 3          5 4           6 5
7 obsidian   8 spotify     9 discord
```

## The scheme

```kdl
workspace "main" {
    open-on-output "DP-1"
}
workspace "browser" {
    open-on-output "DP-1"
}
workspace "sec" {
    open-on-output "DP-1"
}
workspace "3" {
    open-on-output "DP-1"
}
workspace "4" {
    open-on-output "DP-1"
}
workspace "5" {
    open-on-output "DP-1"
}
workspace "discord" {
    open-on-output "DP-2"
}
workspace "obsidian"
workspace "spotify"
```

`obsidian` and `spotify` are left unpinned — you don't care which monitor they first appear on since you always reach them by name.

## The cross-monitor question, answered

Before wiring up binds, it's worth being precise about what `focus-workspace "name"` actually does across two monitors, since the naive scheme above implies something it doesn't do.

**Scenario:** `main` is showing on screen 1 (DP-1). `obsidian` also happens to live on DP-1 right now, sitting unfocused below/above `main` in that monitor's workspace stack. You're currently focused on screen 2 (DP-2) and press `Mod+7` (`focus-workspace "obsidian"`).

**What actually happens:** your focus jumps *over to DP-1*, which switches to show `obsidian` there. DP-2 keeps showing whatever it was already showing, just unfocused now. `obsidian` does **not** come to DP-2.

This follows directly from niri's own mental model (from its docs): *"My first monitor contains these workspaces... I can switch my first monitor to workspace X or Y. I can move workspace Y to my second monitor to show it there."* A workspace only ever displays on its current owning output. `focus-workspace` changes which of that output's workspaces is showing and hands you input focus there — it never relocates the workspace itself. Relocating is a separate, explicit action: `move-workspace-to-monitor-left/right/up/down/next/previous`.

So if what you actually want is "bring `obsidian` to whichever screen I'm already looking at," a plain `focus-workspace "obsidian"` bind isn't enough — you need one extra step.

## Two ways to bind it

**Plain — "go to it":**

```kdl
binds {
    Mod+1 { focus-workspace "main"; }
    Mod+2 { focus-workspace "browser"; }
    Mod+3 { focus-workspace "sec"; }
    Mod+4 { focus-workspace "3"; }
    Mod+5 { focus-workspace "4"; }
    Mod+6 { focus-workspace "5"; }
    Mod+7 { focus-workspace "obsidian"; }
    Mod+8 { focus-workspace "spotify"; }
    Mod+9 { focus-workspace "discord"; }
}
```

Simplest option. Your focus travels to wherever the workspace currently is.

**Wrapper — "bring it to me":**

```sh
#!/usr/bin/env sh
# focus-workspace-here.sh <workspace-name>
# Bring a named workspace to whichever monitor is currently focused.
here=$(niri msg -j focused-output | jq -r '.name')
niri msg action focus-workspace "$1"
there=$(niri msg -j focused-output | jq -r '.name')
if [ "$here" != "$there" ]; then
    niri msg action move-workspace-to-monitor-next
fi
```

With exactly two outputs, `move-workspace-to-monitor-next` is a clean toggle: after `focus-workspace` jumps you to wherever the workspace lives, if that's not the monitor you started on, this one extra call moves that now-focused workspace — and your focus with it — onto your original monitor. This needs `jq` (not currently in `home-manager/home.nix`'s package list).

```kdl
binds {
    Mod+1 { spawn "sh" "-c" "focus-workspace-here.sh main"; }
    Mod+2 { spawn "sh" "-c" "focus-workspace-here.sh browser"; }
    Mod+3 { spawn "sh" "-c" "focus-workspace-here.sh sec"; }
    Mod+4 { spawn "sh" "-c" "focus-workspace-here.sh 3"; }
    Mod+5 { spawn "sh" "-c" "focus-workspace-here.sh 4"; }
    Mod+6 { spawn "sh" "-c" "focus-workspace-here.sh 5"; }
    Mod+7 { spawn "sh" "-c" "focus-workspace-here.sh obsidian"; }
    Mod+8 { spawn "sh" "-c" "focus-workspace-here.sh spotify"; }
    Mod+9 { spawn "sh" "-c" "focus-workspace-here.sh discord"; }
}
```

This is what matches the behavior described in the original question: pressing `Mod+7` on screen 2 pulls `obsidian` there instead of sending your focus away to wherever it was.

## Trade-offs vs. `workflow.md` / `workflow2.md`

- **Upside:** every slot is permanent — `Mod+1` always means `main`, full stop, regardless of what else is open or how many other workspaces exist. No relative move-up/down juggling to keep things reachable.
- **Downside:** you lose niri's scrollable/dynamic "workspaces adapt to what you're doing" model for these 9 slots entirely. Niri's own docs are explicit about this trade-off: *"I suggest not doing that, but instead trying the niri way with dynamic workspaces, focusing and moving up/down instead of by index."* Emulating static workspaces works, but you give up the thing niri is designed around.
- **The "bring it to me" behavior always costs the wrapper script** — there's no config-only way to get it, for any named workspace, on any number of monitors.

## Migration note

This scheme replaces per-monitor index addressing outright — `Mod+1` currently means "1st workspace on the focused monitor" (dynamic, from `home-manager/wm/niri.nix`'s `workspaceBinds`), not a named workspace. Adopting this scheme means:

- Removing the existing `Mod+1..0` / `Mod+Shift+1..0` / `Mod+Shift+Ctrl+1..0` binds generated by `workspaceBinds` in `niri.nix`'s `let` block, since they'd otherwise collide with the new named binds on the same keys.
- Column-moving binds have a direct named equivalent, so nothing is lost there: `move-column-to-workspace` accepts a name just as well as an index (`move-column-to-workspace "browser"` works the same way `move-column-to-workspace 2` does today).

Nothing here has been applied to `niri.nix` — same as the other two docs, this is a reference to wire up yourself if you go this route.
