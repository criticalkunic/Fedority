#!/usr/bin/env bash
set -euo pipefail

# Kara Virtual Desktop Switcher
git clone https://github.com/dhruv8sh/kara.git \
  && cd kara \
  && chmod +x install.sh \
  && ./install.sh \
  && cd .. \
  && rm -rf kara

# Desktop Effects
TMP_DIR="$(mktemp -d)" \
&& URL="$(curl -fsSL https://api.github.com/repos/luisbocanegra/plasma-wallpaper-effects/releases/latest \
  | grep -oE '"browser_download_url":\s*"[^"]+\.plasmoid"' \
  | cut -d'"' -f4 | head -n1)" \
&& curl -fsSL "$URL" -o "$TMP_DIR/widget.plasmoid" \
&& kpackagetool6 -t Plasma/Applet -i "$TMP_DIR/widget.plasmoid" \
&& rm -rf "$TMP_DIR"

# Panel Effects

TMP_DIR="$(mktemp -d)" \
&& URL="$(curl -fsSL https://api.github.com/repos/luisbocanegra/plasma-panel-colorizer/releases/latest \
  | grep -oE '"browser_download_url":\s*"[^"]+\.plasmoid"' \
  | cut -d'"' -f4 | head -n1)" \
&& curl -fsSL "$URL" -o "$TMP_DIR/panel-colorizer.plasmoid" \
&& kpackagetool6 -t Plasma/Applet -i "$TMP_DIR/panel-colorizer.plasmoid" \
&& rm -rf "$TMP_DIR"

