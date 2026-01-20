#!/usr/bin/env bash
set -euo pipefail

ARCHIVE_PATH="../files/kde_config_backup.tar.gz"

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
# Optional: backup existing config before restore
# --------------------------------------------------
PRE_RESTORE_BACKUP="$HOME/kde_pre_restore_backup.tar.gz"

echo "🛡 Creating pre-restore safety backup:"
tar -C "$HOME" -czf "$PRE_RESTORE_BACKUP" \
  .config \
  .local/share/color-schemes \
  .local/share/knewstuff3 \
  .bashrc \
  .zshrc \
  2>/dev/null || true

# --------------------------------------------------
# Restore
# --------------------------------------------------
tar -C "$HOME" -xzf "$ARCHIVE_PATH"

echo "✅ Restore complete"
