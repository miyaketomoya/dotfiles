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

echo "==> 完了しました。"
