#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Config
# --------------------------------------------------
ARCHIVE_PATH="$HOME/kde_config_backup.tar.gz"

# --------------------------------------------------
# Paths relative to $HOME
# Order matters on restore
# --------------------------------------------------
CONFIG_PATHS=(
  # Screen topology (CRITICAL)
  ".local/share/kscreen"

  # Plasma layout
  ".config/plasma-org.kde.plasma.desktop-appletsrc"
  ".config/plasmarc"

  # Core KDE behavior
  ".config/kdeglobals"
  ".config/kwinrc"
  ".config/kglobalshortcutsrc"
  ".config/kscreenlockerrc"
  ".config/ksmserverrc"
  ".config/krunnerrc"
  ".config/dolphinrc"
  ".config/konsolerc"
  ".config/systemsettingsrc"
  ".config/autostart"

  # KDE user data
  ".local/share/color-schemes"
  ".local/share/knewstuff3"

  # Shell config
  ".bashrc"
  ".zshrc"
)

# --------------------------------------------------
# Filter only existing paths
# --------------------------------------------------
EXISTING_PATHS=()
for path in "${CONFIG_PATHS[@]}"; do
  [[ -e "$HOME/$path" ]] && EXISTING_PATHS+=("$path")
done

# --------------------------------------------------
# Create archive
# --------------------------------------------------
echo "🗜 Creating KDE config backup:"
echo "   $ARCHIVE_PATH"

tar -C "$HOME" -czf "$ARCHIVE_PATH" "${EXISTING_PATHS[@]}"

echo "✅ Backup successful"
