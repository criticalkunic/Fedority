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

echo "📦 1/4 Installing RPM Fusion + media stack"
bash "${SCRIPTS_DIR}/apps/media.sh"

echo "🖥 2/4 Configuring terminal (fonts, starship, konsole)"
bash "${SCRIPTS_DIR}/terminal.sh"

echo "🪟 3/4 Applying KDE configuration (KWin, Klassy, Krohnkite)"
bash "${SCRIPTS_DIR}/kde.sh"

echo "🎨 4/4 Installing and applying themes"
bash "${SCRIPTS_DIR}/theme.sh"

echo "Applying Look and Feel"
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r ./lookandfeel/fedority \
  ~/.local/share/plasma/look-and-feel/
lookandfeeltool --apply fedority


# --------------------------------------------------
# Done
# --------------------------------------------------
echo
echo "✅ Bootstrap complete"
echo "ℹ️ Recommended next steps:"
echo "   • Please log out and log back in"
