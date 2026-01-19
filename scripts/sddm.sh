#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="catppuccin-mocha-red"
ZIP_NAME="${THEME_NAME}-sddm.zip"
REPO_API="https://api.github.com/repos/catppuccin/sddm/releases/latest"
THEMES_DIR="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "📦 Installing SDDM theme dependencies"
sudo dnf install -y qt6-qtquickcontrols2 qt6-qtsvg

echo "🔍 Fetching latest Catppuccin SDDM release info"
DOWNLOAD_URL="$(
  curl -fsSL "$REPO_API" \
  | grep -oE '"browser_download_url":\s*"[^"]*'" \
  | cut -d'"' -f4 \
  | grep "$ZIP_NAME"
)"

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "❌ Could not find $ZIP_NAME in latest release"
  exit 1
fi

echo "⬇️  Downloading $ZIP_NAME"
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/$ZIP_NAME"

echo "📂 Extracting theme"
unzip -q "$TMP_DIR/$ZIP_NAME" -d "$TMP_DIR"

echo "🎨 Installing theme to $THEMES_DIR"
sudo mkdir -p "$THEMES_DIR"
sudo rm -rf "$THEMES_DIR/$THEME_NAME"
sudo mv "$TMP_DIR/$THEME_NAME" "$THEMES_DIR/"

echo "🛠️  Configuring SDDM theme"

if [[ -f "$SDDM_CONF" ]]; then
  sudo sed -i \
    -e '/^\[Theme\]/,/^\[/{s/^Current=.*/Current='"$THEME_NAME"'/}' \
    "$SDDM_CONF"

  if ! grep -q '^\[Theme\]' "$SDDM_CONF"; then
    sudo tee -a "$SDDM_CONF" > /dev/null <<EOF

[Theme]
Current=$THEME_NAME
EOF
  fi
else
  sudo tee "$SDDM_CONF" > /dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF
fi

echo "✅ SDDM theme set to: $THEME_NAME"

sudo systemctl restart sddm
