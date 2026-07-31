# dotfiles

個人PCのセットアップ一式。ツールごとにディレクトリを分けて管理しています。現在含まれるもの:

- **[herdr](https://herdr.dev)** — 4ペイン開発レイアウト（claude / terminal /
  [token-dashboard](https://github.com/Davidcreador/herdr-token-dashboard) /
  [reviewr](https://github.com/persiyanov/herdr-reviewr)）用のプラグインinstallコマンド
  + 設定ファイル。
- **[ghostty](https://ghostty.org)** — ターミナル設定。
- **[starship](https://starship.rs)** — シェルプロンプト設定。公式の
  [Tokyo Nightプリセット](https://starship.rs/presets/tokyo-night.html)（ghosttyの
  テーマと統一）をベースに、gitブランチ表示とpythonモジュールを追加したもの。
- **zsh** — `.zshrc`自体は個人設定込みのため含めていないが、追記したスニペットだけ
  `zsh/snippets/` に置いている（`Ctrl+X Ctrl+E`でコマンドラインを`$EDITOR`で編集、
  [fzf](https://github.com/junegunn/fzf)のシェル統合で`Ctrl+R`履歴検索/`Ctrl+T`ファイル
  選択/`Alt+C`のあいまいcd）。

## 構成

```
dotfiles/
├── install.sh
├── herdr/
│   ├── config.toml                                    # 個人設定一式（テーマ・キーバインドなど）
│   └── plugins/config/persiyanov.reviewr/config.toml
├── herdr-plus/
│   ├── worktrees/default.toml                          # repo = "*" のワイルドカードレイアウト
│   └── quick-actions/claude.toml
├── ghostty/
│   └── config.ghostty
├── starship/
│   └── starship.toml
└── zsh/snippets/
    └── edit-command-line.zsh
```

## インストール

```bash
git clone git@github.com:miyaketomoya/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` は各ファイルを `~/.config/...`（macOSのghosttyは
`~/Library/Application Support/...`）にシンボリックリンクとして配置します。既存ファイル
がある場合は先にバックアップ（`<file>.bak.<timestamp>`）を取ります。各ツールの前提コマンド
（例: `herdr`）が無ければ、そのツール分の処理はスキップされます。

`herdr/config.toml` は個人設定を丸ごと含むファイルなので、既存のherdr設定を持つマシンで
実行すると、そのファイルはバックアップされたうえで丸ごと置き換わります。既存設定を残したい
場合は、事前に手動でマージしてください。

**すでに使っているMacで、既存のherdr設定を壊さずherdr/herdr-plus部分だけ入れたい場合**は
`install.sh` を使わず、[MANUAL_SETUP.md](MANUAL_SETUP.md) の手順で必要な部分だけ手で
追記してください。

## herdrセットアップの詳細

- **worktree自動レイアウト**（`herdr-plus/worktrees/default.toml`、`repo = "*"`）は、
  `herdr worktree create` / `herdr worktree open` 実行時に**どのリポジトリでも**自動的に
  発火します。レイアウトは、上段にclaudeを幅いっぱいに配置し、下段にterminal /
  token-dashboard / reviewrを均等3分割で配置します。
  - herdr-plusは配列内の**直前のペイン**からしか分割できない（一直線のチェーン構造）ため、
    任意のグリッド配置はできません。claudeを1つの角だけに固定する厳密な4分割グリッドは
    表現できないため、これは現実的に近い近似形です。
- **Quick Action**（`herdr-plus/quick-actions/claude.toml`）はclaude単体を起動します。
  quick actionsピッカー（`prefix+down`）経由でのみ到達可能です。claudeを1キーで直接起動
  するプラグインアクションが存在しないため、ピッカーを経由する1手間が必要です。
- **reviewrの設定**では `auto_open = false` を指定しています。上記のworktree自動レイア
  ウトがreviewrを明示的に開くため、両方が同じworktreeイベントに反応するとレース状態になる
  のを防ぐためです。
- ベースのherdr設定に追加したキーバインド: `prefix+shift+r`（reviewrのトグル）、
  `prefix+shift+d`（token-dashboardを開く）、`prefix+shift+p`（herdr-plusのprojectsピッカー、
  既存の`prefix+up`のエイリアス）。

試してみる: `herdr worktree open <任意のリポジトリのパス>` — 自動的に4ペインレイアウトが
立ち上がるはずです。

## starshipセットアップの詳細

- `install.sh` は `starship` コマンドが無ければ Homebrew 経由でインストールします
  （Homebrewも無い場合はスキップ）。
- `starship/starship.toml` は他の用途と衝突しない専用ファイルなので、そのままシンボリック
  リンクで `~/.config/starship.toml` に配置します。
- `.zshrc` は個人設定を含む共有ファイルなので、`herdr/config.toml` と違い**丸ごと置き換え
  ません**。`eval "$(starship init zsh)"` の行が無い場合のみ末尾に追記します（既に何らかの
  形でstarshipを初期化済みなら何もしません）。
- プロンプトにはOSアイコン・ディレクトリ・**gitブランチ / 変更状態**・python / nodejs /
  rust / golang / php のバージョン・時刻を表示します。アイコン表示には Nerd Font が必要
  （ghosttyのフォント設定 `PlemolJP35 Console NF` で対応済み）。

## ghostty追加設定について

`copy-on-select`（選択と同時にクリップボードへコピー）に加えて、以下を追加済み:

- `macos-option-as-alt = true` — Optionキーを特殊文字入力ではなくAltとして扱う。zshの
  emacsバインド（`Alt+←/→`で単語移動、`Alt+Backspace`で単語削除）が使えるようになる。
- `mouse-hide-while-typing = true` — 入力中はマウスカーソルを隠す。
- `window-save-state = always` — 再起動後もウィンドウ/タブ構成を復元する。

設定を変更したら `ghostty +validate-config --config-file=<path>` で構文検証できる
（`/Applications/Ghostty.app/Contents/MacOS/ghostty` から実行）。

## ターミナルを本格的なエディタのように使いたい場合

ターミナルの「今まで出力された文字列」は、シェル側から見るとただの過去ログで編集対象では
ないため、複数行を範囲選択してまとめて削除する、といったテキストエディタ的な操作はghostty
単体でもherdr経由でも原理的にできません。編集できるのは常に「現在入力中の1行」だけです。

その制約の中で一番近い体験を作るのが `Ctrl+X Ctrl+E`（`zsh/snippets/edit-command-line.zsh`）
です。今入力中のコマンドをまるごと `$EDITOR`（デフォルト `vim`）に渡して編集し、確定すると
そのままシェルに戻ります。複数行編集・検索置換など、エディタでできることはここに限ってはすべて
使えます。マウス操作（クリックでカーソル移動など）に依存しないキーバインドなので、herdrの
ペインの中でも同じように動作するはずです。

一方、ghosttyのshell integration由来の「クリックでカーソル移動」「Ctrl+トリプルクリックで
コマンド出力選択」は、herdrのようなマルチプレクサ越しだと機能しない可能性があります（詳細は
会話ログ参照）。試して動かなければ、上記の `Ctrl+X Ctrl+E` を使うのがおすすめです。
