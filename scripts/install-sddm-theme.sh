#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="catppuccin-mocha-red"
ZIP_NAME="${THEME_NAME}-sddm.zip"
SDDM_URL="https://github.com/catppuccin/sddm/releases/download/v1.1.2/${ZIP_NAME}"
THEME_DIR="/usr/share/sddm/themes"

echo "🎨 Installing Catppuccin SDDM theme (${THEME_NAME})"

# Dependencies (Fedora)
sudo dnf install -y qt6-qtquickcontrols2 qt6-qtsvg unzip

# Download
TMP_DIR="$(mktemp -d)"
curl -fsSL "$SDDM_URL" -o "${TMP_DIR}/${ZIP_NAME}"

# Install
sudo unzip -o "${TMP_DIR}/${ZIP_NAME}" -d "$THEME_DIR"

# Configure SDDM
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf >/dev/null <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo "✅ SDDM theme set to ${THEME_NAME}"
