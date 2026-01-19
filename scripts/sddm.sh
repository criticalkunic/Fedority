#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Config
# --------------------------------------------------
THEME_NAME="catppuccin-mocha-red"
ZIP_NAME="${THEME_NAME}-sddm.zip"
EXTRACTED_DIR="${THEME_NAME}-sddm"

REPO_API="https://api.github.com/repos/catppuccin/sddm/releases/latest"
THEMES_DIR="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# --------------------------------------------------
# Dependencies
# --------------------------------------------------
echo "📦 Installing SDDM theme dependencies"
sudo dnf install -y qt6-qtquickcontrols2 qt6-qtsvg unzip curl

# --------------------------------------------------
# Fetch release
# --------------------------------------------------
echo "🔍 Fetching latest Catppuccin SDDM release info"

DOWNLOAD_URL="$(
  curl -fsSL "$REPO_API" \
    | grep -oE '"browser_download_url":[^"]*"[^"]*"' \
    | cut -d'"' -f4 \
    | grep -F "$ZIP_NAME" \
    | head -n 1
)"

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "❌ Could not find $ZIP_NAME in latest release"
  exit 1
fi

# --------------------------------------------------
# Download & extract
# --------------------------------------------------
echo "⬇️  Downloading $ZIP_NAME"
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/$ZIP_NAME"

echo "📂 Extracting theme"
unzip -q "$TMP_DIR/$ZIP_NAME" -d "$TMP_DIR"

if [[ ! -d "$TMP_DIR/$EXTRACTED_DIR" ]]; then
  echo "❌ Expected extracted directory $EXTRACTED_DIR not found"
  exit 1
fi

# --------------------------------------------------
# Install theme
# --------------------------------------------------
echo "🎨 Installing theme to $THEMES_DIR"

sudo mkdir -p "$THEMES_DIR"
sudo rm -rf "$THEMES_DIR/$THEME_NAME"
sudo mv "$TMP_DIR/$EXTRACTED_DIR" "$THEMES_DIR/$THEME_NAME"

# --------------------------------------------------
# Configure SDDM
# --------------------------------------------------
echo "🛠️  Configuring SDDM"

sudo mkdir -p "$(dirname "$SDDM_CONF")"

if [[ ! -f "$SDDM_CONF" ]]; then
  sudo tee "$SDDM_CONF" > /dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF
else
  if grep -q '^\[Theme\]' "$SDDM_CONF"; then
    if grep -q '^Current=' "$SDDM_CONF"; then
      sudo sed -i \
        '/^\[Theme\]/,/^\[/{s/^Current=.*/Current='"$THEME_NAME"'/}' \
        "$SDDM_CONF"
    else
      sudo sed -i \
        '/^\[Theme\]/a Current='"$THEME_NAME" \
        "$SDDM_CONF"
    fi
  else
    sudo tee -a "$SDDM_CONF" > /dev/null <<EOF

[Theme]
Current=$THEME_NAME
EOF
  fi
fi

# --------------------------------------------------
# Restart SDDM
# --------------------------------------------------
echo "🔁 Restarting SDDM"
sudo systemctl restart sddm

echo "✅ SDDM theme set to: $THEME_NAME"
