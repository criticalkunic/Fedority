#!/usr/bin/env bash
set -euo pipefail

# ==================================================
# Fedora KDE Bootstrap
# ==================================================

echo "🚀 Starting Fedora KDE bootstrap"

# --------------------------------------------------
# Resolve paths
# --------------------------------------------------
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts"

# Ensure all scripts are executable
find "$SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;

# --------------------------------------------------
# Install desktop applications
# --------------------------------------------------
"${SCRIPTS_DIR}/install/install-desktop-apps.sh"

# --------------------------------------------------
# Install KDE themes (Catppuccin, Klassy, icons, etc.)
# --------------------------------------------------
"${SCRIPTS_DIR}/install/install-kde-themes.sh"

# --------------------------------------------------
# Install Plasma widgets / applets
# --------------------------------------------------
"${SCRIPTS_DIR}/install/install-plasma-widgets.sh"

# --------------------------------------------------
# Install and configure SDDM theme
# --------------------------------------------------
"${SCRIPTS_DIR}/install/install-sddm-theme.sh"

# --------------------------------------------------
# Configure terminal (fonts, Starship, Konsole)
# --------------------------------------------------
"${SCRIPTS_DIR}/configure/configure-terminal.sh"

# --------------------------------------------------
# Apply KDE appearance (colors, cursors, icons, effects)
# --------------------------------------------------
"${SCRIPTS_DIR}/configure/apply-kde-appearance.sh"

# --------------------------------------------------
# Configure window decorations + Konsole profile
# --------------------------------------------------
"${SCRIPTS_DIR}/configure/configure-window-and-terminal.sh"

# --------------------------------------------------
# Restore initial Plasma layout
# --------------------------------------------------
"${SCRIPTS_DIR}/restore/restore-plasma-layout-initial.sh"

# --------------------------------------------------
# Apply the Look and Feel theming now that all required packages and files are available
# --------------------------------------------------
"${SCRIPTS_DIR}/restore/restore-plasma-layout-final.sh"

# --------------------------------------------------
# Disable unwanted default shortcuts
# --------------------------------------------------
kwriteconfig6 \
  --file kglobalshortcutsrc \
  --group services \
  --group org.kde.krunner.desktop \
  --key _launch none

kwriteconfig6 \
  --file kglobalshortcutsrc \
  --group kwin \
  --key Overview none

# --------------------------------------------------
# Done
# --------------------------------------------------
echo
echo "✅ Bootstrap complete"
