# Niri workflow — middle ground: 6 named anchors + relative navigation

A middle ground between `docs/workflow2.md` (dynamic workspaces, only Spotify/Obsidian named) and `docs/workflow3.md` (fully named, 9 fixed slots on `Mod+1..9`). Here, only the workspaces that genuinely deserve a permanent, always-the-same-key slot get named and bound directly. Everything else — extra projects, one-off workspaces, whatever comes up — is reached by stepping through the stack with `Mod+H`/`Mod+L` instead of claiming more number keys.

```
Mod+1 main       Mod+7 obsidian
Mod+2 browser    Mod+8 spotify
Mod+3 sec        Mod+9 discord

Mod+H / Mod+L    step up/down through whatever else is on the monitor
```

`Mod+4`, `Mod+5`, `Mod+6`, and `Mod+0` are deliberately left unbound — see [The leftover keys](#the-leftover-keys) below.

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
workspace "discord" {
    open-on-output "DP-2"
}
workspace "obsidian"
workspace "spotify"
```

`obsidian` and `spotify` are left unpinned — you don't care which monitor they first appear on since you always reach them by name. `main`/`browser`/`sec` anchor to DP-1, `discord` to DP-2, matching the same layout used in the other two docs.

## Binds

```kdl
binds {
    // Fixed anchors — always the same key, no matter what else is open.
    Mod+1 { focus-workspace "main"; }
    Mod+2 { focus-workspace "browser"; }
    Mod+3 { focus-workspace "sec"; }
    Mod+7 { focus-workspace "obsidian"; }
    Mod+8 { focus-workspace "spotify"; }
    Mod+9 { focus-workspace "discord"; }

    // Step through whatever else is on the focused monitor.
    Mod+H { focus-workspace-up; }
    Mod+L { focus-workspace-down; }
    Mod+Shift+H { move-workspace-up; }
    Mod+Shift+L { move-workspace-down; }
}
```

`Mod+H`/`Mod+L` aren't used by anything in `home-manager/wm/niri.nix` today (column focus already sits on `Mod+J`/`Mod+K`), so there's no collision to resolve.

The up/down assignment is arbitrary — `H` here means "back" and `L` means "forward" through the stack, echoing vim's h/l for the previous/next direction rather than left/right. Swap them if the other way feels more natural; niri doesn't care which physical key means which direction.

`Mod+Shift+H/L` (`move-workspace-up/down`) let you reshuffle the *dynamic* workspaces relative to each other — handy since, unlike the six named anchors, they don't have a fixed position to return to.

## The cross-monitor caveat still applies to the named anchors

Same fact as in `workflow3.md`, worth repeating here since it applies to `main`/`browser`/`sec`/`obsidian`/`spotify`/`discord` exactly the same way: `focus-workspace "name"` moves your *focus* to whichever monitor already owns that workspace — it does not pull the workspace onto the monitor you're currently looking at. So pressing `Mod+7` while on DP-2 to reach `obsidian`, if `obsidian` is currently sitting on DP-1, will flip your focus over to DP-1, not bring `obsidian` to DP-2. If you want "bring it to me" behavior instead, see the `focus-workspace-here.sh` wrapper script in `docs/workflow3.md` and use it for these binds the same way.

## Browser and Discord across monitors

Unchanged from the other docs — reuse the existing `Mod+Shift+M` bind (`move-workspace-to-monitor-next`, `home-manager/wm/niri.nix:122`). Focus the `browser` workspace and hit it to push the browser from DP-1 (research) to DP-2 (reference) and back; same bind pulls the `discord` workspace onto DP-1 when you want to write more comfortably.

## Window rules for Spotify / Obsidian / Discord

```kdl
window-rule {
    match app-id="^Spotify$"
    open-on-workspace "spotify"
}

window-rule {
    match app-id="^obsidian$"
    open-on-workspace "obsidian"
}

window-rule {
    match app-id="^discord$"
    open-on-workspace "discord"
}
```

> **Heads up:** `niri.nix` already has `open-on-workspace "spotify"` and `open-on-workspace "discord"` rules, but without matching `workspace "name" { }` declarations they currently fall back to opening on whatever workspace is focused. The `workspace` block above is what makes them (and the new Obsidian rule) actually work.

## The leftover keys

`Mod+4`, `Mod+5`, `Mod+6`, and `Mod+0` stay unbound. Keeping the old per-monitor index binds on just those four keys was considered, but index-based `focus-workspace 4` (etc.) always means "whatever is 4th on this monitor right now" — with the six named anchors reshuffling things around them, slots 4/5/6/10 stop corresponding to anything predictable and just become a source of confusion. `Mod+H`/`Mod+L` already cover reaching anything extra without needing to guess what's currently sitting in an arbitrary numbered slot.

## Migration note

Adopting this scheme means removing the `Mod+1`, `Mod+2`, `Mod+3`, `Mod+7`, `Mod+8`, `Mod+9` entries (and their `Mod+Shift+`/`Mod+Shift+Ctrl+` column-move variants) from the generated `workspaceBinds` in `home-manager/wm/niri.nix`'s `let` block, since those keys are now claimed by the named anchors above. Column-moving to a named workspace still works the same way as by index — `move-column-to-workspace "browser"` instead of `move-column-to-workspace 2`.

Nothing here has been applied to `niri.nix` — same as the other three docs, this is a reference to wire up yourself.
