#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installing Ulauncher"

# --------------------------------------------------
# Install Ulauncher (auto-yes)
# --------------------------------------------------
sudo dnf install -y ulauncher

# --------------------------------------------------
# Ensure pip is available
# --------------------------------------------------
if ! command -v pip3 >/dev/null; then
  echo "📦 Installing python3-pip"
  sudo dnf install -y python3-pip
fi

# --------------------------------------------------
# Install required Python packages
# --------------------------------------------------
echo "🐍 Installing Python dependencies"
pip3 install --user --upgrade argparse jsonschema shutilwhich || true
# argparse + json are stdlib, but this keeps pip happy across distros

# --------------------------------------------------
# Install Catppuccin theme for Ulauncher
# --------------------------------------------------
echo "🎨 Installing Catppuccin Mocha Red theme"
python3 <(curl -fsSL https://raw.githubusercontent.com/catppuccin/ulauncher/main/install.py) \
  -f mocha \
  -a red \
  -r 0

# --------------------------------------------------
# Write Ulauncher settings
# --------------------------------------------------
echo "⚙️ Writing Ulauncher settings"

CONFIG_DIR="${HOME}/.config/ulauncher"
CONFIG_FILE="${CONFIG_DIR}/settings.json"

mkdir -p "${CONFIG_DIR}"

cat > "${CONFIG_FILE}" << 'EOF'
{
  "blacklisted-desktop-dirs": "/usr/share/locale:/usr/share/app-install:/usr/share/kservices5:/usr/share/fk5:/usr/share/kservicetypes5:/usr/share/applications/screensavers:/usr/share/kde4:/usr/share/mimelnk",
  "clear-previous-query": true,
  "disable-desktop-filters": false,
  "grab-mouse-pointer": false,
  "hotkey-show-app": "<Alt>space",
  "render-on-screen": "mouse-pointer-monitor",
  "show-indicator-icon": false,
  "show-recent-apps": "0",
  "terminal-command": "",
  "theme-name": "Catppuccin-Mocha-Red"
}
EOF

# --------------------------------------------------
# Restart Ulauncher
# --------------------------------------------------
echo "🔄 Restarting Ulauncher"

systemctl --user restart ulauncher.service

echo "✅ Ulauncher installed and configured"
