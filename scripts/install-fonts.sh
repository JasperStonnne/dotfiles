#!/usr/bin/env bash
# Download Smile Nerd Font Mono and LXGW WenKai (proportional + Mono) into
# ~/.local/share/fonts/ and refresh the font cache.
#
# Smile = FiraCode + LXGW Wenkai composite, used as primary across all
# generic font families. LXGW kept as further fallback.
set -euo pipefail

FONT_DIR="$HOME/.local/share/fonts"

download() {
  local url="$1"
  local dest="$2"
  if [[ -f "$dest" ]]; then
    echo "  ✓ already present: $(basename "$dest")"
    return
  fi
  echo "  ↓ $(basename "$dest")"
  curl -sSL --fail -o "$dest" "$url"
}

echo "Installing Smile Nerd Font Mono..."
mkdir -p "$FONT_DIR/smile-nerd-font"
download \
  "https://github.com/SOV710/smile-nerd-font/releases/latest/download/SmileNerdFontMono-Regular.ttf" \
  "$FONT_DIR/smile-nerd-font/SmileNerdFontMono-Regular.ttf"
download \
  "https://github.com/SOV710/smile-nerd-font/releases/latest/download/SmileNerdFontMono-Light.ttf" \
  "$FONT_DIR/smile-nerd-font/SmileNerdFontMono-Light.ttf"

echo "Installing LXGW WenKai..."
mkdir -p "$FONT_DIR/lxgw"
download \
  "https://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKai-Regular.ttf" \
  "$FONT_DIR/lxgw/LXGWWenKai-Regular.ttf"
download \
  "https://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKaiMono-Regular.ttf" \
  "$FONT_DIR/lxgw/LXGWWenKaiMono-Regular.ttf"

echo "Refreshing font cache..."
fc-cache -f "$FONT_DIR" >/dev/null

echo "Fonts installed."
