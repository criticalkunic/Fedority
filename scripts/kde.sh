# ==================================================
# KDE config files (Klassy + Krohnkite)
# ==================================================
echo "⚙️ Applying KDE system settings"

# --------------------------------------------------
# Klassy config
# --------------------------------------------------
KLASSY_CONFIG_DIR="${HOME}/.config/klassy"
SOURCE_KLASSYRC="$(dirname "$0")/../files/klassyrc"

mkdir -p "${KLASSY_CONFIG_DIR}"

if [[ -f "${SOURCE_KLASSYRC}" ]]; then
  echo "📄 Installing klassyrc"
  cp "${SOURCE_KLASSYRC}" "${KLASSY_CONFIG_DIR}/klassyrc"
else
  echo "⚠️ klassyrc not found at ${SOURCE_KLASSYRC}"
fi

# --------------------------------------------------
# Krohnkite KWin settings
# --------------------------------------------------
KWINRC="${HOME}/.config/kwinrc"

if ! grep -q "^\[Script-krohnkite\]" "${KWINRC}" 2>/dev/null; then
  echo "🪟 Adding Krohnkite settings to kwinrc"

  cat <<'EOF' >> "${KWINRC}"

[Script-krohnkite]
binaryTreeLayoutOrder=0
cascadeLayoutOrder=0
columnsLayoutOrder=0
floatSkipPagerWindows=true
floatingClass=/home/kunic/Documents/Burrito/burrito.x86_64,burrito.x86_64
floatingTitle=/home/kunic/Documents/Burrito/burrito.x86_64,burrito.x86_64
ignoreActivity=/home/kunic/Documents/Burrito/burrito.x86_64,burrito.x86_64
ignoreClass=krunner,yakuake,spectacle,kded5,xwaylandvideobridge,plasmashell,ksplashqml,org.kde.plasmashell,org.kde.polkit-kde-authentication-agent-1,org.kde.kruler,kruler,kwin_wayland,ksmserver-logout-greeter,burrito.x86_64
ignoreTitle=burrito.x86_64
monocleLayoutOrder=0
preventProtrusion=false
quarterLayoutOrder=0
screenGapBetween=12
screenGapBottom=12
screenGapLeft=12
screenGapRight=12
screenGapTop=12
spiralLayoutOrder=0
spreadLayoutOrder=0
stackedLayoutOrder=0
stairLayoutOrder=0
threeColumnLayoutOrder=1
tileLayoutOrder=0
EOF
else
  echo "ℹ️ Krohnkite settings already present in kwinrc"
fi

# ==================================================
# Enable Krohnkite + KWin Effects + Focus behavior
# ==================================================
echo "🪟 Configuring KWin scripts, effects, and focus"

KWINRC="${HOME}/.config/kwinrc"

# --------------------------------------------------
# Enable Krohnkite KWin Script
# --------------------------------------------------
kwriteconfig5 \
  --file "${KWINRC}" \
  --group Plugins \
  --key krohnkiteEnabled true

# --------------------------------------------------
# Desktop Effects (Appearance)
# --------------------------------------------------

# Blur
kwriteconfig5 --file "${KWINRC}" --group Plugins --key blurEnabled true

# Desaturate Unresponsive Applications
kwriteconfig5 --file "${KWINRC}" --group Plugins --key desaturateunresponsiveEnabled true

# Fading Popups (Kinetic)
kwriteconfig5 --file "${KWINRC}" --group Plugins --key fadingpopupsEnabled true

# Geometry Change
kwriteconfig5 --file "${KWINRC}" --group Plugins --key geometrychangeEnabled true

# Sheet
kwriteconfig5 --file "${KWINRC}" --group Plugins --key sheetEnabled true

# Translucency
kwriteconfig5 --file "${KWINRC}" --group Plugins --key translucencyEnabled true

# --------------------------------------------------
# Focus behavior
# --------------------------------------------------

# Dialogs take focus from parent window
kwriteconfig5 \
  --file "${KWINRC}" \
  --group Windows \
  --key FocusPolicy DialogParent

# Dim screen for administrator mode
kwriteconfig5 \
  --file "${KWINRC}" \
  --group Compositing \
  --key DimAdminMode true

  # ==================================================
# Global Theme, Styles, Icons, Cursor
# ==================================================
echo "🎨 Applying global KDE appearance"

KDEGLOBALS="${HOME}/.config/kdeglobals"
KWINRC="${HOME}/.config/kwinrc"

# --------------------------------------------------
# Global Colors: Catppuccin Mocha Red
# --------------------------------------------------
kwriteconfig5 \
  --file "${KDEGLOBALS}" \
  --group General \
  --key ColorScheme "CatppuccinMochaRed"

# --------------------------------------------------
# Application Style: Breeze
# --------------------------------------------------
kwriteconfig5 \
  --file "${KDEGLOBALS}" \
  --group KDE \
  --key widgetStyle Breeze

# --------------------------------------------------
# Plasma Style: Klassy
# --------------------------------------------------
kwriteconfig5 \
  --file "${KDEGLOBALS}" \
  --group PlasmaTheme \
  --key name Klassy

# --------------------------------------------------
# Window Decorations: Klassy
# --------------------------------------------------
kwriteconfig5 \
  --file "${KWINRC}" \
  --group org.kde.kdecoration2 \
  --key library org.kde.klassy

kwriteconfig5 \
  --file "${KWINRC}" \
  --group org.kde.kdecoration2 \
  --key theme Klassy

# --------------------------------------------------
# Install Reversal icon theme (red)
# --------------------------------------------------
echo "🧩 Installing Reversal icon theme (red)"

ICON_WORKDIR="${HOME}/reversal-icons"

if [[ -d "${ICON_WORKDIR}" ]]; then
  gio trash "${ICON_WORKDIR}"
fi

git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git "${ICON_WORKDIR}"
cd "${ICON_WORKDIR}"

./install.sh -t red

cd "${HOME}"
gio trash "${ICON_WORKDIR}"

# Set icon theme
kwriteconfig5 \
  --file "${KDEGLOBALS}" \
  --group Icons \
  --key Theme Reversal-red-dark

# --------------------------------------------------
# Install macOS cursor theme
# --------------------------------------------------
echo "🖱 Installing macOS cursor theme"

CURSOR_DIR="${HOME}/.local/share/icons"
CURSOR_ARCHIVE="macOS.tar.xz"

mkdir -p "${CURSOR_DIR}"
cd /tmp

if [[ ! -f "${CURSOR_ARCHIVE}" ]]; then
  curl -L -o "${CURSOR_ARCHIVE}" \
    https://github.com/ful1e5/apple_cursor/releases/download/v2.0.1/macOS.tar.xz
fi

tar -xf "${CURSOR_ARCHIVE}" -C "${CURSOR_DIR}"
rm -f "${CURSOR_ARCHIVE}"

# Set cursor theme
kwriteconfig5 \
  --file "${KDEGLOBALS}" \
  --group Icons \
  --key CursorTheme macOS

# --------------------------------------------------
# Reload KDE components
# --------------------------------------------------
echo "🔄 Reloading KDE appearance"
qdbus org.kde.KWin /KWin reconfigure || true
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.reloadTheme || true

echo "✅ Global KDE appearance configured"
