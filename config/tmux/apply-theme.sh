#!/usr/bin/env sh

set -eu

detect_theme() {
  if command -v defaults >/dev/null 2>&1 &&
    defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
    printf '%s\n' dark
  else
    printf '%s\n' light
  fi
}

theme="${1:-auto}"
if [ "$theme" = auto ]; then
  theme="$(detect_theme)"
fi

set_color() {
  tmux set-option -gq "@ukiyo-color-$1" "$2"
}

case "$theme" in
dark)
  tmux set-option -gq @ukiyo-theme "kanagawa/wave"
  set_color text "#DCD7BA"
  set_color bg-bar "#1F1F28"
  set_color bg-pane "#1F1F28"
  set_color highlight "#7E9CD8"
  set_color selection "#54546D"
  set_color info "#7AA89F"
  set_color accent "#7E9CD8"
  set_color notice "#FFA066"
  set_color error "#E46876"
  set_color muted "#938AA9"
  set_color alert "#FF9E3B"
  mode_style="bg=#C0A36E,fg=#1F1F28,bold"
  ;;
light)
  tmux set-option -gq @ukiyo-theme "catppuccin/latte"
  set_color text "#4C4F69"
  set_color bg-bar "#EFF1F5"
  set_color bg-pane "#EFF1F5"
  set_color highlight "#1E66F5"
  set_color selection "#CCD0DA"
  set_color info "#209FB5"
  set_color accent "#1E66F5"
  set_color notice "#FE640B"
  set_color error "#D20F39"
  set_color muted "#8C8FA1"
  set_color alert "#DF8E1D"
  mode_style="bg=#1E66F5,fg=#EFF1F5,bold"
  ;;
*)
  printf 'usage: %s [auto|dark|light]\n' "$0" >&2
  exit 2
  ;;
esac

ukiyo="${HOME}/.tmux/plugins/tmux-ukiyo/ukiyo.tmux"
if [ -f "$ukiyo" ]; then
  "$ukiyo"
fi

tmux set-window-option -gq mode-style "$mode_style"
tmux set-window-option -gq copy-mode-selection-style "$mode_style"
