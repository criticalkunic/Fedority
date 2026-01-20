#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="Fedority"
SOURCE_DIR="$HOME/look-and-feel/$THEME_NAME"
DEST_DIR="$HOME/.local/share/plasma/look-and-feel/$THEME_NAME"

echo "🎨 Installing KDE Look-and-Feel: $THEME_NAME"

# --------------------------------------------------
# Sanity checks
# --------------------------------------------------
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "❌ Source theme not found:"
  echo "   $SOURCE_DIR"
  exit 1
fi

# --------------------------------------------------
# Install Look-and-Feel
# --------------------------------------------------
mkdir -p "$HOME/.local/share/plasma/look-and-feel"
rm -rf "$DEST_DIR"

cp -r "$SOURCE_DIR" "$DEST_DIR"

echo "📦 Theme installed to:"
echo "   $DEST_DIR"

# --------------------------------------------------
# Apply Look-and-Feel
# --------------------------------------------------
echo "🚀 Applying Look-and-Feel: $THEME_NAME"
lookandfeeltool --apply "$THEME_NAME"

echo "✅ Look-and-Feel '$THEME_NAME' applied successfully"
