#!/usr/bin/env bash
set -euo pipefail


# Kill Plasma to prevent overwriting
echo "🛑 Asking Plasma to shut down cleanly..."
kquitapp6 plasmashell || true

echo "⏳ Waiting for Plasma to exit..."
for i in {1..20}; do
  pgrep -x plasmashell >/dev/null || break
  sleep 0.5
done

if pgrep -x plasmashell >/dev/null; then
  echo "❌ Plasma did not exit cleanly"
  exit 1
fi

# --------------------------------------------------
# Restore KDE config (relative to this script)
# --------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESTORE_SCRIPT="$SCRIPT_DIR/../../support/restore.sh"

if [[ -f "$RESTORE_SCRIPT" ]]; then
  echo "📦 Restoring KDE configuration"
  chmod +x "$RESTORE_SCRIPT"
  "$RESTORE_SCRIPT"
else
  echo "⚠️  Restore script not found:"
  echo "   $RESTORE_SCRIPT"
fi

echo "🧹 Clearing Plasma cache..."
rm -rf ~/.cache/plasma*
rm -rf ~/.cache/org.kde.plasmashell

echo "🚀 Restarting Plasma..."
plasmashell --replace >/dev/null 2>&1 &

echo "✅ Plasma layout restored"

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
