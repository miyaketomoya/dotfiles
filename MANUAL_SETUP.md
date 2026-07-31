# 手動セットアップ手順（herdr / herdr-plus 限定）

`install.sh` は `herdr/config.toml` を丸ごとシンボリックリンクで置き換えるため、そのMacに
すでに別のherdr設定（テーマや他プラグインのキーバインドなど）がある場合は事故りやすいです。
このページは、既存設定を壊さずに **必要な部分だけ手で追記する** ための手順です。

対象は herdr と herdr-plus のみ（ghosttyは含みません）。

前提: **herdr >= 0.7.0** が導入済み。

## 1. プラグインをインストール

これは他の設定を書き換えないので、そのまま実行して大丈夫です。

```bash
herdr plugin install persiyanov/herdr-reviewr
herdr plugin install cloudmanic/herdr-plus
herdr plugin install Davidcreador/herdr-token-dashboard
```

## 2. worktree自動レイアウトを追加

まず既存ファイルの有無を確認します。

```bash
ls ~/.config/herdr-plus/worktrees/
```

- **何も無ければ**、このリポジトリのファイルをそのままコピーしてOKです。

  ```bash
  mkdir -p ~/.config/herdr-plus/worktrees
  cp ~/dotfiles/herdr-plus/worktrees/default.toml ~/.config/herdr-plus/worktrees/default.toml
  ```

- **`default.toml` が既にあり中身が違う**場合は、上書きせず別名で置きます（`repo` 名の
  重複さえなければ複数ファイルは共存できます）。

  ```bash
  cp ~/dotfiles/herdr-plus/worktrees/default.toml ~/.config/herdr-plus/worktrees/dotfiles-wildcard.toml
  ```

  ただし `repo = "*"` のワイルドカードファイルが既にある場合、2つ同時には効きません
  （herdr-plusのREADMEにある優先順位: 同名repo+branch > repoのみ > wildcard+branch >
  wildcardのみ、を参照）。既存のワイルドカードの中身を見て、必要なパネル構成をそちらに
  手で追記する方が安全です。

## 3. Claude用のQuick Actionを追加

```bash
ls ~/.config/herdr-plus/quick-actions/
```

同様に、無ければそのままコピー。

```bash
mkdir -p ~/.config/herdr-plus/quick-actions
cp ~/dotfiles/herdr-plus/quick-actions/claude.toml ~/.config/herdr-plus/quick-actions/claude.toml
```

ファイル名の衝突だけ気をつければ、Quick Actionsはファイル単位で追加されていくだけなので
ここは比較的安全です。

## 4. reviewrの設定

```bash
cat ~/.config/herdr/plugins/config/persiyanov.reviewr/config.toml 2>/dev/null
```

- **ファイルが無ければ**、このリポジトリの内容をそのままコピー。

  ```bash
  mkdir -p ~/.config/herdr/plugins/config/persiyanov.reviewr
  cp ~/dotfiles/herdr/plugins/config/persiyanov.reviewr/config.toml \
     ~/.config/herdr/plugins/config/persiyanov.reviewr/config.toml
  ```

- **既にあれば**、以下の3行だけを手で追記・上書きしてください（他の設定はそのまま残す）。

  ```toml
  auto_open = false
  toggle_placement = "split"
  toggle_direction = "right"
  ```

  `auto_open = false` は必須です。worktree自動レイアウト側でreviewrを明示的に開くため、
  両方が同じworktreeイベントに反応するとレースします。

## 5. herdr本体の config.toml（ここが一番注意が必要）

**このファイルは絶対に丸ごと上書きしないこと。** 追記するのは `[[keys.command]]` ブロック
だけです。

まず現状をバックアップします。

```bash
cp ~/.config/herdr/config.toml ~/.config/herdr/config.toml.bak
```

既存の内容を確認し、`prefix+shift+r` / `prefix+shift+d` / `prefix+shift+p` が既に別の用途
で使われていないか確認してください（キーの重複は設定ファイル全体を無効にする可能性があり
ます）。問題なければ、テキストエディタで `~/.config/herdr/config.toml` の末尾に以下を追記
します。

```toml
[[keys.command]]
key = "prefix+shift+r"
type = "plugin_action"
command = "persiyanov.reviewr.toggle"
description = "toggle reviewr"

[[keys.command]]
key = "prefix+shift+d"
type = "plugin_action"
command = "dave.token-dashboard.open-dashboard"
description = "open token dashboard"

[[keys.command]]
key = "prefix+shift+p"
type = "plugin_action"
command = "cloudmanic.herdr-plus.projects"
description = "herdr-plus: projects (alias of prefix+up)"
```

`prefix+shift+p` はすでに `prefix+up` などでprojectsピッカーを開けるなら不要なので、
省略しても構いません。

## 6. 反映

```bash
herdr server reload-config
```

問題があれば `~/.config/herdr/config.toml.bak` に戻せば元通りです。

```bash
cp ~/.config/herdr/config.toml.bak ~/.config/herdr/config.toml
herdr server reload-config
```
