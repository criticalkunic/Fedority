#!/usr/bin/env bash
set -euo pipefail

echo "📦 Installing RPM Fusion + media codecs"

FEDORA_VERSION="$(rpm -E %fedora)"

# --------------------------------------------------
# Enable RPM Fusion
# --------------------------------------------------
echo "🔓 Enabling RPM Fusion"

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

sudo dnf -y upgrade --refresh

# --------------------------------------------------
# Multimedia codecs (Fedora recommended set)
# --------------------------------------------------
echo "🎬 Installing multimedia codecs"

sudo dnf install -y \
  ffmpeg \
  ffmpeg-libs \
  gstreamer1-libav \
  gstreamer1-plugins-base \
  gstreamer1-plugins-good \
  gstreamer1-plugins-bad-free \
  gstreamer1-plugins-ugly \
  gstreamer1-plugins-ugly-free

# --------------------------------------------------
# Hardware video acceleration (safe defaults)
# --------------------------------------------------
echo "🧠 Installing VA-API / Vulkan helpers"

sudo dnf install -y \
  libva \
  libva-utils \
  mesa-vulkan-drivers \
  mesa-vulkan-drivers.i686 \
  mesa-libGL.i686

# --------------------------------------------------
# Gaming-related multimedia bits
# --------------------------------------------------
echo "🎮 Gaming multimedia support"

sudo dnf install -y \
  steam-devices \
  pipewire-jack-audio-connection-kit \
  mangohud \
  gamemode

# --------------------------------------------------
# Enable GameMode
# --------------------------------------------------
sudo systemctl enable --now gamemoded.service || true

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
echo "🧹 Cleaning up"

sudo dnf autoremove -y
sudo dnf clean all

echo "✅ Media & RPM Fusion setup complete"
