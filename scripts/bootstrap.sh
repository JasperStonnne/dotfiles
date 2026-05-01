#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WITH_GNOME=0
WITH_APT=0
WITH_FONTS=0

for arg in "$@"; do
  case "$arg" in
    --with-gnome)
      WITH_GNOME=1
      ;;
    --with-apt)
      WITH_APT=1
      ;;
    --with-fonts)
      WITH_FONTS=1
      ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [--with-gnome] [--with-apt] [--with-fonts]" >&2
      exit 1
      ;;
  esac
done

install_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

install_dir() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  cp -r "$src" "$dest"
}

install_file "$ROOT/bash/.bashrc" "$HOME/.bashrc"
install_file "$ROOT/xinput/.xinputrc" "$HOME/.xinputrc"
install_file "$ROOT/gtk/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
install_dir "$ROOT/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
install_dir "$ROOT/gtk/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
install_dir "$ROOT/autostart/.config/autostart" "$HOME/.config/autostart"
install_dir "$ROOT/applications/.local/share/applications" "$HOME/.local/share/applications"
install_dir "$ROOT/fcitx5/.config/fcitx5" "$HOME/.config/fcitx5"
install_dir "$ROOT/fcitx5-data/.local/share/fcitx5/themes" "$HOME/.local/share/fcitx5/themes"
install_dir "$ROOT/fcitx5-data/.local/share/fcitx5/rime" "$HOME/.local/share/fcitx5/rime"
install_dir "$ROOT/fontconfig/.config/fontconfig" "$HOME/.config/fontconfig"

# Claude Code memory: project dir is $HOME with slashes -> dashes.
if [[ -d "$ROOT/claude-memory/memory" ]]; then
  CLAUDE_PROJECT="$(echo "$HOME" | tr '/' '-')"
  install_dir "$ROOT/claude-memory/memory" \
    "$HOME/.claude/projects/$CLAUDE_PROJECT/memory"
fi

# fontconfig changed: refresh cache so existing fonts pick up new aliases.
if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f >/dev/null
fi

if [[ "$WITH_GNOME" -eq 1 && -f "$ROOT/gnome/gnome.dconf" ]]; then
  dconf load /org/gnome/ < "$ROOT/gnome/gnome.dconf"
fi

if [[ "$WITH_APT" -eq 1 && -f "$ROOT/packages/apt-manual.txt" ]]; then
  sudo apt update
  xargs -r -a "$ROOT/packages/apt-manual.txt" sudo apt install -y
fi

if [[ "$WITH_FONTS" -eq 1 && -x "$ROOT/scripts/install-fonts.sh" ]]; then
  "$ROOT/scripts/install-fonts.sh"
fi

echo "Bootstrap complete."
