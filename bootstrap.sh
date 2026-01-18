#!/usr/bin/env bash
set -euo pipefail

# ==================================================
# Fedora KDE Bootstrap
# ==================================================

echo "🚀 Sytarting Fedora KDE bootstrap"

# --------------------------------------------------
# Resolve paths
# --------------------------------------------------
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts"

# --------------------------------------------------
# Ensure script permissions (readable, not executable)
# --------------------------------------------------
echo "🔧 Normalizing script permissions"

chmod -R u+rX "${SCRIPTS_DIR}"

# --------------------------------------------------
# Sanity checks
# --------------------------------------------------
if [[ "$XDG_CURRENT_DESKTOP" != *"KDE"* ]]; then
  echo "❌ This bootstrap is intended for KDE Plasma only"
  exit 1
fi

if ! command -v kwriteconfig5 >/dev/null; then
  echo "❌ kwriteconfig5 not found. Are KDE tools installed?"
  exit 1
fi

# --------------------------------------------------
# Order matters
# --------------------------------------------------

echo "📦 1/5 Installing Applications"
bash "${SCRIPTS_DIR}/apps.sh"

echo "🖥 2/5 Configuring terminal (fonts, starship, konsole)"
bash "${SCRIPTS_DIR}/terminal.sh"

echo "🪟 3/5 Applying KDE configuration (KWin, Klassy, Krohnkite)"
bash "${SCRIPTS_DIR}/kde.sh"

echo "🎨 4/5 Installing themes"
bash "${SCRIPTS_DIR}/theme.sh"

echo "🎨 5/5 Configuring Look and Feel"
bash "${SCRIPTS_DIR}/lookandfeel.sh"

kwriteconfig6 \
  --file kglobalshortcutsrc \
  --group services \
  --group org.kde.krunner.desktop \
  --key _launch none

  kwriteconfig6 \
  --file kglobalshortcutsrc \
  --group kwin \
  --key "Window Close" \
  "Meta+W\tAlt+F4,Alt+F4,Close Window"

  kwriteconfig6 \
  --file kglobalshortcutsrc \
  --group kwin \
  --key Overview \
  "Meta\tMeta,Toggle Overview"

# --------------------------------------------------
# Done
# --------------------------------------------------
echo
echo "✅ Bootstrap complete"
