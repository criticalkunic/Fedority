#!/usr/bin/env bash
set -euo pipefail

# ==================================================
# KWin Window Decorations
# ==================================================

echo "🪟 Removing all titlebar buttons"

KWINRC="$HOME/.config/kwinrc"

kwriteconfig6 \
  --file "$KWINRC" \
  --group org.kde.kdecoration2 \
  --key ButtonsOnLeft ""

kwriteconfig6 \
  --file "$KWINRC" \
  --group org.kde.kdecoration2 \
  --key ButtonsOnRight ""

# ==================================================
# Konsole Scratchy Colorscheme + Profile
# ==================================================

SCHEME_NAME="Scratchy"
SCHEME_FILE="${SCHEME_NAME}.colorscheme"
SCHEME_URL="https://gitlab.com/jomada/Scratchy/-/raw/main/konsole/${SCHEME_FILE}"

KONSOLE_DIR="$HOME/.local/share/konsole"
PROFILE_NAME="Scratchy"
PROFILE_FILE="${KONSOLE_DIR}/${PROFILE_NAME}.profile"

FONT_STRING="NotoSansM Nerd Font Mono,12,-1,5,400,0,0,0,0,0,0,0,1"

mkdir -p "$KONSOLE_DIR"

echo "⬇️  Downloading Scratchy colorscheme"
curl -fsSL "$SCHEME_URL" -o "$KONSOLE_DIR/$SCHEME_FILE"

echo "🎨 Patching Scratchy transparency (Plasma 6)"

# Remove any existing [General] block
sed -i '/^\[General\]/,/^\[/d' "$KONSOLE_DIR/$SCHEME_FILE"

# Append the exact block Konsole writes
cat >> "$KONSOLE_DIR/$SCHEME_FILE" <<'EOF'

[General]
Anchor=0.5,0.5
Blur=true
ColorRandomization=false
Description=Scratchy
FillStyle=Tile
Opacity=0.75
Wallpaper=
WallpaperFlipType=NoFlip
WallpaperOpacity=1
EOF


# ==================================================
# Create Konsole Profile
# ==================================================

echo "🧩 Creating Scratchy Konsole profile"

cat > "$PROFILE_FILE" <<EOF
[Appearance]
ColorScheme=${SCHEME_NAME}
Font=${FONT_STRING}

[General]
Name=${PROFILE_NAME}
Parent=FALLBACK/
EOF


# ==================================================
# Set Scratchy as Default Konsole Profile
# ==================================================

echo "⭐ Setting Scratchy as default Konsole profile"

kwriteconfig5 \
  --file "$HOME/.config/konsolerc" \
  --group "Desktop Entry" \
  --key DefaultProfile "${PROFILE_NAME}.profile"

echo "✅ Scratchy colorscheme, font, and transparency applied"


# ==================================================
# Reload KWin (apply decoration changes)
# ==================================================

echo "🔄 Reloading KWin"
qdbus org.kde.KWin /KWin reconfigure
