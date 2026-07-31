#!/usr/bin/env bash
# Symlinks this repo's config files into place (backing up any existing file
# first, as *.bak.<timestamp>), and installs the herdr plugins this setup
# depends on. Editing a symlinked file later edits the copy in this repo too.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

if command -v herdr >/dev/null 2>&1; then
  echo "==> Installing herdr plugins"
  herdr plugin install persiyanov/herdr-reviewr
  herdr plugin install cloudmanic/herdr-plus
  herdr plugin install Davidcreador/herdr-token-dashboard

  echo "==> Linking herdr config files"
  link "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
  link "$DOTFILES_DIR/herdr/plugins/config/persiyanov.reviewr/config.toml" "$HOME/.config/herdr/plugins/config/persiyanov.reviewr/config.toml"
  link "$DOTFILES_DIR/herdr-plus/worktrees/default.toml" "$HOME/.config/herdr-plus/worktrees/default.toml"
  link "$DOTFILES_DIR/herdr-plus/quick-actions/claude.toml" "$HOME/.config/herdr-plus/quick-actions/claude.toml"

  echo "==> Restart herdr, or run: herdr server reload-config"
else
  echo "herdr not found on PATH, skipping herdr plugins/config."
fi

if [ -d "$HOME/Library/Application Support" ]; then
  echo "==> Linking ghostty config"
  link "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
fi

echo "==> Done."
