# Niri workflow

A guide for recreating an XMonad-style workflow (easy workspace switching across two monitors, plus always-available scratchpad apps) using niri's own model instead of fighting it.

## Niri's model, in one paragraph

XMonad has static, numbered workspaces you assign to a screen. Niri is the opposite: workspaces are **dynamic and per-monitor** — each monitor has its own stack of workspaces, they get created/destroyed automatically as you use them, and there's no "the app is in scratchpad" concept at all (no `move to scratchpad` / `show scratchpad` like i3/sway has). The niri-native replacement for "static workspace" and "scratchpad" is the same primitive: a **named workspace**. Named workspaces always exist (even empty), can be jumped to by name from anywhere with `focus-workspace "name"`, and pair with `focus-workspace-previous` as a universal "go back to what I was doing" key. That combination — jump-to-name + jump-back — gives you scratchpad-like instant access without niri needing to support scratchpads as a special case.

Current outputs (`home-manager/wm/niri.nix`): `DP-1` is the 4K main monitor, `DP-2` is the 1440p secondary monitor.

## Recommended workspace layout

| Named workspace | Home output       | Purpose                                       |
| --------------- | ----------------- | --------------------------------------------- |
| `frontend`      | DP-1 (main)       | 1–2 terminals + VS Code                       |
| `backend`       | DP-1 (main)       | 1–2 terminals + VS Code                       |
| `browser`       | DP-1 (main)       | Research; move to DP-2 when used as reference |
| `discord`       | DP-2 (secondary)  | Chat; pull to DP-1 when writing more          |
| `spotify`       | wherever it opens | Always-there, jump to it and back             |
| `obsidian`      | wherever it opens | Always-there, jump to it and back             |

Everything here is expressed as niri config you can paste in — nothing below has been applied to `niri.nix` yet.

## Declaring the named workspaces

```kdl
workspace "frontend" {
    open-on-output "DP-1"
}

workspace "backend" {
    open-on-output "DP-1"
}

workspace "browser" {
    open-on-output "DP-1"
}

workspace "discord" {
    open-on-output "DP-2"
}

workspace "spotify"
workspace "obsidian"
```

`spotify` and `obsidian` are left without `open-on-output` on purpose — you don't care which monitor they first appear on, since you'll always reach them by jumping to the name.

> **Heads up:** `niri.nix` already has window-rules with
> `open-on-workspace "spotify"` and `open-on-workspace "discord"`, but
> `open-on-workspace` only works if a matching `workspace "name" { }` is
> declared at the top level — otherwise it silently falls back to opening on
> whatever workspace is currently focused. Since those workspaces were never
> declared, those two rules currently do nothing. Adding the block above fixes
> that for free.

## Window rules

Add one for Obsidian (Discord/Spotify already exist, just currently dead per
the note above):

```kdl
window-rule {
    match app-id="^obsidian$"
    open-on-workspace "obsidian"
}
```

## Keybinds

```kdl
binds {
    // Universal "go back to what I was doing" — pairs with any focus-workspace jump below.
    Mod+Tab { focus-workspace-previous; }

    // Instant access from anywhere, like the old XMonad scratchpads.
    Mod+S { focus-workspace "spotify"; }
    Mod+N { focus-workspace "obsidian"; }
}
```

Jump in with `Mod+S` / `Mod+N`, jump back to whatever you were doing with `Mod+Tab`.

## Moving things between monitors

No new bind needed here — `Mod+Shift+M` is already bound to `move-workspace-to-monitor-next` (`home-manager/wm/niri.nix:108`). With exactly two outputs, that's already a clean toggle:

- **Browser, research → reference:** focus the `browser` workspace, hit `Mod+Shift+M` to push it from DP-1 to DP-2 once you're done researching and just want it as a reference off to the side. Hit it again to bring it back for the next research pass.
- **Discord, pulled in to write:** focus the `discord` workspace on DP-2, hit `Mod+Shift+M` to pull it onto the main monitor when you want to write more comfortably; hit it again to send it back.

## Optional: dropdown-style overlay instead of a full workspace switch

If jumping workspaces for Spotify/Obsidian ever feels too heavy and you'd rather have them pop in as a floating overlay on top of whatever you're looking at, niri supports that too via `open-floating` and `default-floating-position`:

```kdl
window-rule {
    match app-id="^obsidian$"

    open-on-workspace "obsidian"
    open-floating true
    default-floating-position x=0 y=0 relative-to="top"
    default-window-height { proportion 0.6; }
    default-column-width { proportion 0.5; }
}
```

Note floating layers are per-workspace/per-monitor in niri (not global), so this only gives you the dropdown look while you're already on the `obsidian` workspace — you'd still use `Mod+N` to jump there first.
