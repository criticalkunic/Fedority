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

./install.sh 1 5 2

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
#!/usr/bin/env bash
set -euo pipefail

REPO_API="https://codeberg.org/api/v1/repos/anametologin/Krohnkite/releases/latest"
TMP_DIR="$(mktemp -d)"
SCRIPT_ID="krohnkite"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "🔍 Fetching latest Krohnkite release info..."

RELEASE_JSON="$(curl -fsSL "$REPO_API")"

KWINSCRIPT_URL="$(
  echo "$RELEASE_JSON" \
  | grep -oE '"browser_download_url":"[^"]+\.kwinscript"' \
  | head -n 1 \
  | sed 's/.*"browser_download_url":"//;s/"$//'
)"

if [[ -z "$KWINSCRIPT_URL" ]]; then
  echo "❌ No .kwinscript asset found in the latest release."
  exit 1
fi

FILENAME="$(basename "$KWINSCRIPT_URL")"

echo "⬇️  Downloading $FILENAME"
curl -fL "$KWINSCRIPT_URL" -o "$TMP_DIR/$FILENAME"

SCRIPT_DIR="$HOME/.local/share/kwin/scripts/krohnkite"

if [[ -d "$SCRIPT_DIR" ]]; then
  echo "✔ Krohnkite already installed at $SCRIPT_DIR. Skipping."
else
  echo "📦 Installing KWin script..."
  kpackagetool6 --type=KWin/Script -i "$TMP_DIR/$FILENAME"
fi

echo "⚙️  Enabling Krohnkite..."
kwriteconfig6 \
  --file kwinrc \
  --group Plugins \
  --key "$SCRIPT_ID" true

echo "🔄 Reloading KWin..."
qdbus org.kde.KWin /KWin reconfigure || true

echo "✅ Krohnkite installed and enabled"


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
