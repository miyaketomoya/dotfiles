#!/usr/bin/env bash
# Installs the herdr plugins and symlinks this repo's config files into
# ~/.config/herdr and ~/.config/herdr-plus. Existing files are backed up
# (renamed to *.bak.<timestamp>) before being replaced with a symlink, so
# editing the symlinked file later edits the copy in this repo too.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v herdr >/dev/null 2>&1; then
  echo "herdr command not found on PATH. Install herdr (>= 0.7.0) first." >&2
  exit 1
fi

echo "==> Installing plugins"
herdr plugin install persiyanov/herdr-reviewr
herdr plugin install cloudmanic/herdr-plus
herdr plugin install Davidcreador/herdr-token-dashboard

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%s)"
    echo "backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

echo "==> Linking config files"
link "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link "$DOTFILES_DIR/herdr/plugins/config/persiyanov.reviewr/config.toml" "$HOME/.config/herdr/plugins/config/persiyanov.reviewr/config.toml"
link "$DOTFILES_DIR/herdr-plus/worktrees/default.toml" "$HOME/.config/herdr-plus/worktrees/default.toml"
link "$DOTFILES_DIR/herdr-plus/quick-actions/claude.toml" "$HOME/.config/herdr-plus/quick-actions/claude.toml"

echo "==> Done. Restart herdr, or run: herdr server reload-config"
