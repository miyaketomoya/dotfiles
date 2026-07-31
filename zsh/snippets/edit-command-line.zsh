# ~/.zshrc に追記済みのスニペット（参照用）。
# Ctrl+X Ctrl+E で、今入力中のコマンドラインを $EDITOR で編集できる。
# 複数行の編集・矩形選択・置換など、テキストエディタの機能をそのまま使える。
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line
