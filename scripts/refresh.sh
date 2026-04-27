#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p \
  "$ROOT/bash" \
  "$ROOT/xinput" \
  "$ROOT/gtk/.config" \
  "$ROOT/autostart/.config" \
  "$ROOT/applications/.local/share/applications" \
  "$ROOT/fcitx5/.config" \
  "$ROOT/fcitx5-data/.local/share/fcitx5" \
  "$ROOT/gnome" \
  "$ROOT/packages"

cp "$HOME/.bashrc" "$ROOT/bash/.bashrc"
cp "$HOME/.xinputrc" "$ROOT/xinput/.xinputrc"
cp "$HOME/.gtkrc-2.0" "$ROOT/gtk/.gtkrc-2.0"
rm -rf "$ROOT/gtk/.config/gtk-3.0" "$ROOT/gtk/.config/gtk-4.0"
cp -r "$HOME/.config/gtk-3.0" "$ROOT/gtk/.config/gtk-3.0"
cp -r "$HOME/.config/gtk-4.0" "$ROOT/gtk/.config/gtk-4.0"
rm -rf "$ROOT/autostart/.config/autostart"
cp -r "$HOME/.config/autostart" "$ROOT/autostart/.config/autostart"
mkdir -p "$ROOT/applications/.local/share/applications"
cp "$HOME/.local/share/applications/cc-switch-handler.desktop" \
  "$HOME/.local/share/applications/clash-verge-handler.desktop" \
  "$HOME/.local/share/applications/mimeapps.list" \
  "$ROOT/applications/.local/share/applications/"
rm -rf "$ROOT/fcitx5/.config/fcitx5"
cp -r "$HOME/.config/fcitx5" "$ROOT/fcitx5/.config/fcitx5"
rm -rf "$ROOT/fcitx5-data/.local/share/fcitx5/themes" "$ROOT/fcitx5-data/.local/share/fcitx5/rime"
cp -r "$HOME/.local/share/fcitx5/themes" "$ROOT/fcitx5-data/.local/share/fcitx5/themes"
mkdir -p "$ROOT/fcitx5-data/.local/share/fcitx5/rime"
cp "$HOME/.local/share/fcitx5/rime/custom_phrase.txt" \
  "$HOME/.local/share/fcitx5/rime/installation.yaml" \
  "$HOME/.local/share/fcitx5/rime/user.yaml" \
  "$ROOT/fcitx5-data/.local/share/fcitx5/rime/"
cp -r "$HOME/.local/share/fcitx5/rime/rime_ice.userdb" \
  "$HOME/.local/share/fcitx5/rime/sync" \
  "$ROOT/fcitx5-data/.local/share/fcitx5/rime/"

apt-mark showmanual > "$ROOT/packages/apt-manual.txt"

if command -v snap >/dev/null 2>&1; then
  timeout 5 snap list > "$ROOT/packages/snap.txt" || true
fi

dconf dump /org/gnome/ > "$ROOT/gnome/gnome.dconf"

echo "Dotfiles refreshed."
