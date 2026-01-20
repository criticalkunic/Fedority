#!/usr/bin/env bash
set -euo pipefail

PROFILE_NAME="Fedority"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KNSV_PATH="${SCRIPT_DIR}/../files/Fedority.knsv"

SHARE_SRC="$HOME/.local/share"
EXPORT_SUBDIR="export/share_folder"

FOLDERS=(
  fonts
  icons
  aurorae
  konsole
  kwin
  plasma
)

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "🧩 Installing konsave (user-local)"
pip install --user setuptools
pip install --user git+https://github.com/michal-gora/konsave.git@pkg_resources_warning_fix

export PATH="$HOME/.local/bin:$PATH"

if ! command -v konsave >/dev/null; then
  echo "❌ konsave not found in PATH"
  echo "ℹ️  Ensure ~/.local/bin is in your PATH"
  exit 1
fi

if [[ ! -f "$KNSV_PATH" ]]; then
  echo "❌ Layout file not found: $KNSV_PATH"
  exit 1
fi

echo "📦 Extracting KNSV (ZIP archive)"
unzip -q "$KNSV_PATH" -d "$TMP_DIR"

EXPORT_PATH="$TMP_DIR/$EXPORT_SUBDIR"
mkdir -p "$EXPORT_PATH"

echo "📁 Injecting ~/.local/share assets into KNSV"

for folder in "${FOLDERS[@]}"; do
  SRC="$SHARE_SRC/$folder"
  DEST="$EXPORT_PATH/$folder"

  if [[ -d "$SRC" ]]; then
    echo "  ➕ Adding $folder"
    rm -rf "$DEST"
    mkdir -p "$DEST"
    cp -a "$SRC/." "$DEST/"
  else
    echo "  ⚠️  Skipping $folder (not found in ~/.local/share)"
  fi
done

echo "📦 Repacking KNSV (ZIP format)"
(
  cd "$TMP_DIR"
  zip -qr "$KNSV_PATH" .
)

echo "📥 Importing KDE layout: $PROFILE_NAME"
konsave -i "$KNSV_PATH"

echo "♻️  Restoring KDE layout: $PROFILE_NAME"
konsave -a "$PROFILE_NAME"

echo "🎨 Applying KDE Plasma appearance settings"

# --------------------------------------------------
# Color Scheme: Catppuccin Mocha Red
# --------------------------------------------------
echo "🎨 Setting color scheme: Catppuccin Mocha Red"
plasma-apply-colorscheme CatppuccinMochaRed

# --------------------------------------------------
# Cursor Theme: macOS
# --------------------------------------------------
echo "🖱️  Setting cursor theme: macOS"
plasma-apply-cursortheme macOS

# --------------------------------------------------
# Set wallpaper
# --------------------------------------------------
echo "🖼 Setting wallpaper"

USER_HOME="${HOME}"
WALLPAPER_DIR="${USER_HOME}/Pictures/Wallpapers"

mkdir -p "${WALLPAPER_DIR}"

WALLPAPER_PATH="${WALLPAPER_DIR}/catppuccin-rainbow.png"

curl -L -o "${WALLPAPER_PATH}" \
  https://github.com/zhichaoh/catppuccin-wallpapers/raw/main/misc/rainbow.png

sudo dnf install qdbus

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (i=0; i<allDesktops.length; i++) {
  d = allDesktops[i];
  d.wallpaperPlugin = 'org.kde.image';
  d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
  d.writeConfig('Image', 'file://${WALLPAPER_PATH}');
}
"

echo "✅ KDE appearance successfully applied"
