#!/usr/bin/env bash
set -euo pipefail

USER_HOME="${HOME}"
FONT_DIR="${USER_HOME}/.local/share/fonts"
KONSOLE_DIR="${USER_HOME}/.local/share/konsole"
COLOR_SCHEME_NAME="Catppuccin-Mocha"
WALLPAPER_DIR="${USER_HOME}/Pictures/Wallpapers"

echo "🖥 Installing Starship + terminal theming"

# --------------------------------------------------
# 1. Install Starship via COPR
# --------------------------------------------------
echo "⭐ Installing Starship"

sudo dnf -y copr enable atim/starship
sudo dnf -y install starship

# --------------------------------------------------
# 2. Install Noto Nerd Font
# --------------------------------------------------
echo "🔤 Installing Noto Nerd Font"

mkdir -p "${FONT_DIR}"
cd /tmp

if [[ ! -f Noto.zip ]]; then
  curl -L -o Noto.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
fi

unzip -o Noto.zip -d "${FONT_DIR}"
fc-cache -fv

# --------------------------------------------------
# 3. Set Konsole default font
# --------------------------------------------------
echo "🧾 Setting Konsole font"

kwriteconfig5 \
  --file konsolerc \
  --group "Desktop Entry" \
  --key DefaultProfile "Default.profile"

kwriteconfig5 \
  --file "${KONSOLE_DIR}/Default.profile" \
  --group Appearance \
  --key Font "Noto Nerd Font,10,-1,5,50,0,0,0,0,0"

# --------------------------------------------------
# 4. Enable Starship in bash
# --------------------------------------------------
echo "🐚 Enabling Starship in bash"

if ! grep -q 'starship init bash' "${USER_HOME}/.bashrc"; then
  echo '' >> "${USER_HOME}/.bashrc"
  echo '# Starship prompt' >> "${USER_HOME}/.bashrc"
  echo 'eval "$(starship init bash)"' >> "${USER_HOME}/.bashrc"
fi

# --------------------------------------------------
# 5. Install Scratchy color scheme for Konsole
# --------------------------------------------------
echo "🎨 Installing Scratchy Konsole color scheme"

KONSOLE_DIR="${HOME}/.local/share/konsole"
mkdir -p "${KONSOLE_DIR}"

curl -L -o "${KONSOLE_DIR}/Scratchy.colorscheme" \
  https://gitlab.com/jomada/Scratchy/-/raw/main/color-schemes/Scratchy.colors

echo "✅ Scratchy Konsole color scheme installed"

# --------------------------------------------------
# 6. Set default Konsole color scheme
# --------------------------------------------------
echo "🎯 Setting Konsole default color scheme"

kwriteconfig5 \
  --file "${KONSOLE_DIR}/Default.profile" \
  --group Appearance \
  --key ColorScheme "${COLOR_SCHEME_NAME}"

  echo "🎨 Applying Konsole color scheme to default profile"

KONSOLE_CONFIG="${USER_HOME}/.config/konsolerc"
PROFILE_DIR="${USER_HOME}/.local/share/konsole"

# Get default profile name
DEFAULT_PROFILE="$(grep -m1 '^DefaultProfile=' "$KONSOLE_CONFIG" | cut -d= -f2)"

# Fallback if not found
if [[ -z "$DEFAULT_PROFILE" ]]; then
  DEFAULT_PROFILE="Default.profile"
fi

PROFILE_PATH="${PROFILE_DIR}/${DEFAULT_PROFILE}"

# Ensure profile exists
if [[ -f "$PROFILE_PATH" ]]; then
  if grep -q '^ColorScheme=' "$PROFILE_PATH"; then
    sed -i "s/^ColorScheme=.*/ColorScheme=${COLOR_SCHEME_NAME}/" "$PROFILE_PATH"
  else
    echo "ColorScheme=${COLOR_SCHEME_NAME}" >> "$PROFILE_PATH"
  fi
else
  echo "⚠️ Konsole profile not found: $PROFILE_PATH"
fi

# Reload Konsole config
qdbus org.kde.konsole /konsole/MainWindow_1 org.kde.konsole.reloadSettings 2>/dev/null || true

echo "✅ Terminal theming complete (restart Konsole for full effect)"
