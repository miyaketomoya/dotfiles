# dotfiles

個人PCのセットアップ一式。ツールごとにディレクトリを分けて管理しています。現在含まれるもの:

- **[herdr](https://herdr.dev)** — 4ペイン開発レイアウト（claude / terminal /
  [token-dashboard](https://github.com/Davidcreador/herdr-token-dashboard) /
  [reviewr](https://github.com/persiyanov/herdr-reviewr)）用のプラグインinstallコマンド
  + 設定ファイル。
- **[ghostty](https://ghostty.org)** — ターミナル設定。
- *（starshipはこのマシンにまだ導入されていません。導入したら `starship/`
  ディレクトリを作り、`install.sh` にsymlink処理を追加してください）*

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
└── ghostty/
    └── config.ghostty
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
