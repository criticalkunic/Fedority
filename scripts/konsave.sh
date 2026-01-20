#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Restore KDE config (relative to this script)
# --------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESTORE_SCRIPT="$SCRIPT_DIR/../support/restore.sh"

if [[ -f "$RESTORE_SCRIPT" ]]; then
  echo "📦 Restoring KDE configuration"
  chmod +x "$RESTORE_SCRIPT"
  "$RESTORE_SCRIPT"
else
  echo "⚠️  Restore script not found:"
  echo "   $RESTORE_SCRIPT"
fi

# --------------------------------------------------
# Color Scheme: Catppuccin Mocha Red
# --------------------------------------------------
echo "🎨 Setting color scheme: Catppuccin Mocha Red"
plasma-apply-colorscheme CatppuccinMochaRed

# --------------------------------------------------
# Cursor Theme: macOS
# --------------------------------------------------
echo "🖱️  Setting cursor theme: macOS"
plasma-apply-cursortheme macOS

# --------------------------------------------------
# Set wallpaper
# --------------------------------------------------
echo "🖼 Setting wallpaper"

USER_HOME="${HOME}"
WALLPAPER_DIR="${USER_HOME}/Pictures/Wallpapers"
mkdir -p "${WALLPAPER_DIR}"

WALLPAPER_PATH="${WALLPAPER_DIR}/catppuccin-rainbow.png"

curl -L -o "${WALLPAPER_PATH}" \
  https://github.com/zhichaoh/catppuccin-wallpapers/raw/main/misc/rainbow.png

sudo dnf install -y qdbus

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (i=0; i<allDesktops.length; i++) {
  d = allDesktops[i];
  d.wallpaperPlugin = 'org.kde.image';
  d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
  d.writeConfig('Image', 'file://${WALLPAPER_PATH}');
}
"

echo "✅ KDE appearance successfully applied"
