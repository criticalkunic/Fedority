#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE_PATH="$SCRIPT_DIR/../files/kde_config_backup.tar.gz"

# --------------------------------------------------
# Sanity checks
# --------------------------------------------------
if [[ ! -f "$ARCHIVE_PATH" ]]; then
  echo "❌ Backup archive not found:"
  echo "   $ARCHIVE_PATH"
  exit 1
fi

echo "📦 Restoring KDE configuration from:"
echo "   $ARCHIVE_PATH"

# --------------------------------------------------
# Detect correct kquitapp
# --------------------------------------------------
if command -v kquitapp6 >/dev/null; then
  KQUIT="kquitapp6"
else
  KQUIT="kquitapp5"
fi

# --------------------------------------------------
# Ask Plasma to exit cleanly
# --------------------------------------------------
echo "🛑 Stopping Plasma shell safely..."
$KQUIT plasmashell || true

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
# Restore SCREEN TOPOLOGY FIRST (fixes panel size swap)
# --------------------------------------------------
echo "🖥 Restoring screen layout (KScreen)..."
tar -C "$HOME" -xzf "$ARCHIVE_PATH" \
  .local/share/kscreen || true

# --------------------------------------------------
# Restore Plasma layout + core config
# --------------------------------------------------
echo "📐 Restoring Plasma layout..."
tar -C "$HOME" -xzf "$ARCHIVE_PATH" \
  .config/plasma-org.kde.plasma.desktop-appletsrc \
  .config/plasmarc \
  .config/kdeglobals \
  .config/kwinrc \
  .config/kglobalshortcutsrc \
  .config/kscreenlockerrc \
  .config/ksmserverrc \
  .config/krunnerrc \
  .config/dolphinrc \
  .config/konsolerc \
  .config/systemsettingsrc \
  .config/autostart

# --------------------------------------------------
# Clear Plasma caches (prevents geometry recalculation)
# --------------------------------------------------
echo "🧹 Clearing Plasma caches..."
rm -rf ~/.cache/plasma*
rm -rf ~/.cache/org.kde.plasmashell
rm -rf ~/.cache/kioexec

# --------------------------------------------------
# Restart Plasma
# --------------------------------------------------
echo "🚀 Restarting Plasma..."
plasmashell --replace >/dev/null 2>&1 &

echo "✅ KDE layout restored successfully"
