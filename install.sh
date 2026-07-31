#!/usr/bin/env bash
# このリポジトリ内の設定ファイルを本来の場所にシンボリックリンクとして配置し
# （既存ファイルがあれば *.bak.<timestamp> としてバックアップ）、
# このセットアップが依存するherdrプラグインをインストールする。
# シンボリックリンク先を編集すると、このリポジトリ内のファイルも変更される。
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%s)"
    echo "既存の $dest をバックアップしました"
  fi
  ln -sfn "$src" "$dest"
  echo "リンクしました: $dest -> $src"
}

if command -v herdr >/dev/null 2>&1; then
  echo "==> herdrプラグインをインストール中"
  herdr plugin install persiyanov/herdr-reviewr
  herdr plugin install cloudmanic/herdr-plus
  herdr plugin install Davidcreador/herdr-token-dashboard

  echo "==> herdrの設定ファイルをリンク中"
  link "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
  link "$DOTFILES_DIR/herdr/plugins/config/persiyanov.reviewr/config.toml" "$HOME/.config/herdr/plugins/config/persiyanov.reviewr/config.toml"
  link "$DOTFILES_DIR/herdr-plus/worktrees/default.toml" "$HOME/.config/herdr-plus/worktrees/default.toml"
  link "$DOTFILES_DIR/herdr-plus/quick-actions/claude.toml" "$HOME/.config/herdr-plus/quick-actions/claude.toml"

  echo "==> herdrを再起動するか、herdr server reload-config を実行してください"
else
  echo "herdrがPATH上に見つからないため、herdr関連のプラグイン・設定はスキップします。"
fi

if [ -d "$HOME/Library/Application Support" ]; then
  echo "==> ghosttyの設定をリンク中"
  link "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
fi

if ! command -v starship >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "==> starshipをインストール中"
    brew install starship
  else
    echo "starshipもHomebrewも無いため、starshipのインストールはスキップします。"
  fi
fi

if command -v starship >/dev/null 2>&1; then
  echo "==> starshipの設定をリンク中"
  link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

  # .zshrcは個人設定を含む共有ファイルなので、丸ごと置き換えず初期化行だけ追記する
  ZSHRC="$HOME/.zshrc"
  if [ -f "$ZSHRC" ] && ! grep -q "starship init" "$ZSHRC"; then
    printf '\n# Added by dotfiles: starship prompt\neval "$(starship init zsh)"\n' >> "$ZSHRC"
    echo "$ZSHRC に starship init 行を追記しました"
  fi
fi

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "edit-command-line" "$ZSHRC"; then
  echo "==> .zshrcにedit-command-line（Ctrl+X Ctrl+Eで\$EDITOR編集）を追記中"
  {
    echo ""
    echo "# Added by dotfiles: edit current command line in \$EDITOR (like a text editor)"
    cat "$DOTFILES_DIR/zsh/snippets/edit-command-line.zsh"
  } >> "$ZSHRC"
fi

if ! command -v fzf >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "==> fzfをインストール中"
    brew install fzf
  else
    echo "fzfもHomebrewも無いため、fzfのインストールはスキップします。"
  fi
fi

if command -v fzf >/dev/null 2>&1 && [ -f "$ZSHRC" ] && ! grep -q "fzf --zsh" "$ZSHRC"; then
  echo "==> .zshrcにfzfのシェル統合を追記中"
  {
    echo ""
    echo "# Added by dotfiles: fzf shell integration (Ctrl+R history, Ctrl+T file, Alt+C cd)"
    cat "$DOTFILES_DIR/zsh/snippets/fzf.zsh"
  } >> "$ZSHRC"
fi

echo "==> 完了しました。"
