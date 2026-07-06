# Niri workflow — without named workspaces

An alternative to `docs/workflow.md` for people who'd rather not declare `workspace "name" { }` blocks for their day-to-day project/browser/Discord workflow. Frontend, backend, browser, and Discord are all handled with niri's plain dynamic workspaces plus relative navigation. Spotify and Obsidian are the one exception: they're used like scratchpads — always there, jump-to-and-back from anywhere, even after being closed — and named workspaces are the right tool for exactly that job, so this doc still declares those two.

## Why skip named workspaces (mostly)

Dynamic workspaces plus index/relative navigation (`focus-workspace N`, `focus-workspace-up/down`, `move-workspace-up/down`) already scale safely as you add or remove workspaces — an index like `focus-workspace 2` is recomputed at runtime to mean "whatever is currently 2nd on this monitor," so nothing breaks or needs updating when a new workspace shows up. You don't strictly need named workspaces to avoid fragility, but if you'd rather not maintain `workspace "name" { }` declarations for your project/browser/Discord workflow, this doc shows the alternative for those.

Spotify and Obsidian are handled differently below — they're the two apps you want reachable from anywhere at a moment's notice, and that specific "always exists, addressable by name" guarantee is exactly what named workspaces are for.

## Arranging frontend / backend / browser

This directly follows niri's own suggested workflow (from its docs' "Example workflow" section): keep the browser on the topmost workspace of the main monitor (DP-1), one workspace per project below it, and actively move workspaces up/down so whichever project you're currently on sits directly below the browser. That makes a single up/down hop the entire "switch to browser and back" motion, no matter which project workspace is currently active.

`home-manager/wm/niri.nix` doesn't currently bind `focus-workspace-up/down` or `move-workspace-up/down` — today it only has the index-based `Mod+1..0` binds and column-focus binds (`Mod+J/K`). Add these to get the relative motion above:

```kdl
binds {
    Mod+Page_Down { focus-workspace-down; }
    Mod+Page_Up   { focus-workspace-up; }
    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
}
```

Workflow: open the browser first (it'll usually be workspace 1 on DP-1). Start frontend or backend work below it. When you switch from, say, frontend to backend, use `Mod+Shift+Page_Down/Up` on the backend workspace to slide it right under the browser — now `Mod+Page_Up` from anywhere on that monitor always reaches the browser in one hop, and `Mod+Page_Down` goes back to whatever you just moved into place.

## Coding on DP-1 with a reference open on DP-2

This is the part the "browser and Discord across monitors" framing undersold: DP-1 and DP-2 are independent monitors in niri, each with their own workspace stack. Once a workspace is parked on DP-2, it just sits there displaying whatever it has — you don't need to keep swapping anything back and forth to "have a reference open while coding." The swap (`Mod+Shift+M`) is a one-time transition you make when research is done and you're ready to code against it, not a per-glance action.

The flow:

1. **Research phase:** browser workspace lives on DP-1 (the bigger, easier-to-read main monitor), full focus, no code in view.
2. **Switch to reference mode:** once you've found what you need, focus that browser workspace and hit `Mod+Shift+M` (`move-workspace-to-monitor-next`, already bound in `home-manager/wm/niri.nix:122`) to relocate it onto DP-2. Then focus your `frontend`/`backend` workspace on DP-1 and start coding — the browser just stays visible on DP-2 the whole time, untouched, in parallel.
3. **Glancing at / scrolling the reference:** you don't need to leave your coding workspace to see it — it's right there on the other monitor. To actually interact with it (scroll, click, search), either:
   - hit `Mod+M` (`focus-monitor-next`, already bound at `home-manager/wm/niri.nix:121`) to jump keyboard focus to DP-2 and back, or
   - enable `focus-follows-mouse` in the `input { }` block so moving your mouse cursor onto DP-2 focuses it automatically — no keybind needed, just look over and scroll:
     ```kdl
     input {
         focus-follows-mouse
         // ...existing settings
     }
     ```
4. **Back to research:** when you need to look something new up at full size, `Mod+Shift+M` again sends the browser workspace back to DP-1. Repeat the cycle as needed.

Discord works the same way in reverse: it lives on DP-2 by default, and the same `Mod+Shift+M` bind pulls its workspace onto DP-1 when you want to write more comfortably, then sends it back.

## Spotify / Obsidian instant access

These two get named workspaces, declared at the top level:

```kdl
workspace "spotify"
workspace "obsidian"
```

No `open-on-output` needed — you don't care which monitor they first appear on, since you'll always reach them by jumping to the name rather than by monitor position.

Window rules to route each app onto its workspace when it opens:

```kdl
window-rule {
    match app-id="^Spotify$"
    open-on-workspace "spotify"
}

window-rule {
    match app-id="^obsidian$"
    open-on-workspace "obsidian"
}
```

> **Heads up:** `home-manager/wm/niri.nix` already has an `open-on-workspace "spotify"` rule, but without a `workspace "spotify" { }` declaration it silently falls back to opening on whatever workspace is currently focused. Adding the two `workspace` lines above is what actually makes that rule (and the new Obsidian one) work.

Keybinds — jump straight to either app from anywhere, and back to whatever you were doing:

```kdl
binds {
    Mod+S { focus-workspace "spotify"; }
    Mod+N { focus-workspace "obsidian"; }
    Mod+Tab { focus-workspace-previous; }
}
```

Unlike the frontend/backend/browser arrangement above, these two workspaces are declared once and don't need any relative move-up/down juggling — you always reach them the same way regardless of how many other workspaces you've since opened.

## Fallback: Overview

`Mod+O` is niri's built-in `toggle-overview` — a zoomed-out view of every workspace and window across both monitors that you can click into directly. No named-workspace setup required; use it whenever you've lost track of where something went.

---

Nothing here has been applied to `niri.nix` — same as `workflow.md`, this is a reference to wire up yourself.
