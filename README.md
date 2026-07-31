# dotfiles

Personal machine setup, one directory per tool. Currently:

- **[herdr](https://herdr.dev)** — plugin installs + config for a 4-pane dev layout
  (claude / terminal / [token-dashboard](https://github.com/Davidcreador/herdr-token-dashboard)
  / [reviewr](https://github.com/persiyanov/herdr-reviewr)).
- **[ghostty](https://ghostty.org)** — terminal config.
- *(starship not set up on this machine yet — add a `starship/` dir + symlink in
  `install.sh` once it is.)*

## Layout

```
dotfiles/
├── install.sh
├── herdr/
│   ├── config.toml                                    # full personal config (theme, keybindings, ...)
│   └── plugins/config/persiyanov.reviewr/config.toml
├── herdr-plus/
│   ├── worktrees/default.toml                          # repo = "*" wildcard layout
│   └── quick-actions/claude.toml
└── ghostty/
    └── config.ghostty
```

## Install

```bash
git clone git@github.com:miyaketomoya/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks each file into place under `~/.config/...` (or
`~/Library/Application Support/...` for ghostty on macOS), backing up any existing
file first (`<file>.bak.<timestamp>`). It only touches a tool's files if that tool's
prerequisite is present (e.g. herdr plugins/config are skipped if `herdr` isn't on
`PATH`).

Because `herdr/config.toml` is a full personal file (not just a snippet), running this
on a machine with its own existing herdr config will back that file up and replace it
wholesale — merge manually first if you want to keep that machine's own settings.

## herdr setup details

- **Worktree auto-layout** (`herdr-plus/worktrees/default.toml`, `repo = "*"`) fires
  automatically for **any** repo on `herdr worktree create` / `herdr worktree open`.
  Layout: claude full-width on top; terminal / token-dashboard / reviewr as three even
  panes underneath.
  - herdr-plus only supports splitting a pane off the *previous* pane in the array (a
    linear chain), not arbitrary grid targeting, so a literal 4-quadrant grid with
    claude locked to one corner isn't expressible — this is the closest practical
    approximation.
- **Quick action** (`herdr-plus/quick-actions/claude.toml`) launches `claude` alone,
  reachable via the quick-actions picker (`prefix+down`). There's no plugin action to
  launch claude directly with a single key, so this needs the picker as an extra step.
- **reviewr config** sets `auto_open = false`, because the worktree auto-layout above
  opens reviewr itself; both reacting to the same worktree event would race.
- Keybindings added on top of the base herdr config: `prefix+shift+r` (toggle reviewr),
  `prefix+shift+d` (open token-dashboard), `prefix+shift+p` (herdr-plus projects
  picker, alias of the pre-existing `prefix+up`).

Try it: `herdr worktree open <path-to-any-repo>` — the 4-pane layout should appear
automatically.
