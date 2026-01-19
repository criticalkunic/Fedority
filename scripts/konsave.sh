#!/usr/bin/env bash
set -euo pipefail

PROFILE_NAME="Fedority"
KNSV_PATH="../files/Fedority.knsv"

echo "🧩 Installing konsave (user-local)"
pip install setuptools
pip install git+https://github.com/michal-gora/konsave.git@pkg_resources_warning_fix

# Ensure konsave is available in this shell
export PATH="$HOME/.local/bin:$PATH"

if ! command -v konsave >/dev/null; then
  echo "❌ konsave not found in PATH"
  echo "ℹ️  Make sure ~/.local/bin is in your PATH"
  exit 1
fi

if [[ ! -f "$KNSV_PATH" ]]; then
  echo "❌ Layout file not found: $KNSV_PATH"
  exit 1
fi

echo "📥 Importing KDE layout: $PROFILE_NAME"
konsave -i "$KNSV_PATH"

echo "♻️  Restoring KDE layout: $PROFILE_NAME"
konsave -a "$PROFILE_NAME"

echo "✅ Layout restored successfully"
echo "⚠️  A logout or Plasma restart may be required"
