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
echo "🪟 Installing Krohnkite (KWin script)"

kpackagetool6 -t KWin/Script -s krohnkite || true

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
