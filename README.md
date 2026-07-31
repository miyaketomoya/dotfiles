# herdr-dotfiles

Personal [herdr](https://herdr.dev) plugin setup: install commands + config files for
a 4-pane dev layout (claude / terminal / [token-dashboard](https://github.com/Davidcreador/herdr-token-dashboard)
/ [reviewr](https://github.com/persiyanov/herdr-reviewr)), driven by
[herdr-plus](https://github.com/cloudmanic/herdr-plus)'s worktree auto-layout, plus a
few keybindings for opening each tool directly.

## What this sets up

- **Plugins**: `persiyanov/herdr-reviewr`, `cloudmanic/herdr-plus`,
  `Davidcreador/herdr-token-dashboard`.
- **Worktree auto-layout** (`herdr-plus/worktrees/default.toml`, `repo = "*"`) — fires
  automatically for **any** repo on `herdr worktree create` / `herdr worktree open`.
  Layout: claude full-width on top; terminal / token-dashboard / reviewr as three even
  panes underneath.
  - Note: herdr-plus only supports splitting a pane off the *previous* pane in the
    array (a linear chain), not arbitrary grid targeting. A literal 4-quadrant grid
    with claude locked to one corner isn't expressible that way — this layout is the
    closest practical approximation.
- **Quick action** (`herdr-plus/quick-actions/claude.toml`) — launches `claude` alone,
  reachable via the quick-actions picker (`prefix+down`). There's no plugin action to
  launch claude directly with a single key, so this needs the picker as an extra step.
- **reviewr config** (`herdr/plugins/config/persiyanov.reviewr/config.toml`) —
  `auto_open = false`, because the worktree auto-layout above opens reviewr itself; both
  reacting to the same worktree event would race.
- **herdr `config.toml`** — full personal config (theme, other plugin keybindings,
  etc.), including these additions on top of what was already there:
  - `prefix+shift+r` → toggle reviewr
  - `prefix+shift+d` → open token-dashboard
  - `prefix+shift+p` → herdr-plus projects picker (alias of the pre-existing
    `prefix+up`)

## Install

Requires **herdr >= 0.7.0** on `PATH`.

```bash
git clone <this-repo-url> ~/herdr-dotfiles
cd ~/herdr-dotfiles
./install.sh
```

`install.sh`:
1. Installs the three plugins via `herdr plugin install`.
2. Symlinks each config file from this repo into `~/.config/herdr/...` and
   `~/.config/herdr-plus/...`, backing up any existing file first
   (`<file>.bak.<timestamp>`).

Because `herdr/config.toml` here is a full personal file (not just a snippet), running
this on a machine that already has its own herdr config will back that file up and
replace it wholesale — merge manually instead of running `install.sh` blindly if you
want to keep an existing config's personal settings.

After linking, restart herdr or run `herdr server reload-config`.

## Try it

```bash
herdr worktree open <path-to-any-repo>
```

The 4-pane layout should appear automatically. Individual tools:
`prefix+shift+r` (reviewr), `prefix+shift+d` (dashboard),
`prefix+down` → "Claude" (quick action), `prefix+up` (projects picker — empty until
you add project files under `~/.config/herdr-plus/projects/`).
