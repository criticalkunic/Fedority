#!/usr/bin/env bash
set -euo pipefail

WORKDIR="${HOME}/catppuccin-kde"
KLASSY_DIR="${HOME}/klassy"

echo "🎨 Installing Catppuccin KDE themes"

# --------------------------------------------------
# 1. Clone Catppuccin KDE
# --------------------------------------------------
if [[ -d "${WORKDIR}" ]]; then
  echo "⚠️ Existing catppuccin-kde directory found, moving to trash"
  gio trash "${WORKDIR}"
fi

git clone --depth=1 https://github.com/catppuccin/kde "${WORKDIR}"
cd "${WORKDIR}"

# --------------------------------------------------
# 2. Run Catppuccin installer (interactive)
# --------------------------------------------------
echo
echo "👉 When prompted, select in order:"
echo "   1 → Mocha"
echo "   5 → Red"
echo "   2 → Classic"
echo

./install.sh

# --------------------------------------------------
# 3. Cleanup Catppuccin repo
# --------------------------------------------------
cd "${HOME}"
gio trash "${WORKDIR}"

echo "✅ Catppuccin KDE themes installed"
echo "ℹ️ Theme is installed but not yet applied"

# ==================================================
# Krohnkite (KWin Script)
# ==================================================
echo "📥 Fetching latest Krohnkite .kwinscript release…"

# Get latest Krohnkite release info from GitHub
LATEST_INFO="$(curl -s https://api.github.com/repos/esjeon/krohnkite/releases/latest)"

# Extract URL to .kwinscript asset
KWINSCRIPT_URL="$(echo "$LATEST_INFO" \
  | grep -E "browser_download_url.*\\.kwinscript" \
  | head -n1 \
  | cut -d '"' -f4)"

if [[ -z "$KWINSCRIPT_URL" ]]; then
  echo "❌ Could not find latest Krohnkite .kwinscript URL"
  exit 1
fi

# Temp file to save .kwinscript
TEMP_KSCRIPT="$(mktemp --suffix=.kwinscript)"

echo "➡ Downloading Krohnkite release from: $KWINSCRIPT_URL"
curl -L "$KWINSCRIPT_URL" -o "$TEMP_KSCRIPT"

# Install with kpackagetool6
echo "📦 Installing Krohnkite script…"
kpackagetool6 -t KWin/Script -i "$TEMP_KSCRIPT"

# Cleanup
rm -f "$TEMP_KSCRIPT"
echo "🧹 Cleaned up temporary files"

echo "✅ Krohnkite installation attempted — enable via System Settings (or config)"

# ==================================================
# Klassy (Plasma 6 window decoration)
# ==================================================
echo "🧱 Installing Klassy dependencies"

sudo dnf install -y \
  git \
  cmake \
  extra-cmake-modules \
  gettext \
  "cmake(KF5Config)" \
  "cmake(KF5CoreAddons)" \
  "cmake(KF5FrameworkIntegration)" \
  "cmake(KF5GuiAddons)" \
  "cmake(KF5Kirigami2)" \
  "cmake(KF5WindowSystem)" \
  "cmake(KF5I18n)" \
  "cmake(Qt5DBus)" \
  "cmake(Qt5Quick)" \
  "cmake(Qt5Widgets)" \
  "cmake(Qt5X11Extras)" \
  "cmake(KDecoration3)" \
  "cmake(KF6ColorScheme)" \
  "cmake(KF6Config)" \
  "cmake(KF6CoreAddons)" \
  "cmake(KF6FrameworkIntegration)" \
  "cmake(KF6GuiAddons)" \
  "cmake(KF6I18n)" \
  "cmake(KF6KCMUtils)" \
  "cmake(KF6KirigamiPlatform)" \
  "cmake(KF6WindowSystem)" \
  "cmake(Qt6Core)" \
  "cmake(Qt6DBus)" \
  "cmake(Qt6Quick)" \
  "cmake(Qt6Svg)" \
  "cmake(Qt6Widgets)" \
  "cmake(Qt6Xml)"

# --------------------------------------------------
# Clone & install Klassy
# --------------------------------------------------
if [[ -d "${KLASSY_DIR}" ]]; then
  echo "⚠️ Existing klassy directory found, moving to trash"
  gio trash "${KLASSY_DIR}"
fi

git clone https://github.com/paulmcauley/klassy "${KLASSY_DIR}"
cd "${KLASSY_DIR}"

git checkout plasma6.3

./install.sh

# --------------------------------------------------
# Cleanup Klassy repo
# --------------------------------------------------
cd "${HOME}"
gio trash "${KLASSY_DIR}"

echo "✅ Klassy installed"
echo "ℹ️ Enable Klassy in System Settings → Window Decorations"
