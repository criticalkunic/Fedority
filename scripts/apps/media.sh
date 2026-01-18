#!/usr/bin/env bash
set -euo pipefail

echo "📦 Fedora RPM Fusion + Multimedia bootstrap"

FEDORA_VERSION="$(rpm -E %fedora)"

# --------------------------------------------------
# Enable RPM Fusion (free + nonfree)
# --------------------------------------------------
echo "🔓 Enabling RPM Fusion repositories"

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

# --------------------------------------------------
# Refresh system
# --------------------------------------------------
echo "🔄 Refreshing package metadata"

sudo dnf upgrade --refresh -y

# --------------------------------------------------
# Replace Fedora ffmpeg-free with RPM Fusion ffmpeg
# --------------------------------------------------
echo "🎬 Swapping ffmpeg-free → ffmpeg (RPM Fusion)"

sudo dnf swap -y \
  ffmpeg-free \
  ffmpeg \
  --allowerasing || true

# --------------------------------------------------
# Install full multimedia stack (RPM Fusion approved)
# --------------------------------------------------
echo "🎥 Installing multimedia group (full codec support)"

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# --------------------------------------------------
# GStreamer plugins (explicit safety net)
# --------------------------------------------------
echo "🎞 Installing GStreamer plugins"

sudo dnf install -y \
  gstreamer1-libav \
  gstreamer1-plugins-base \
  gstreamer1-plugins-good \
  gstreamer1-plugins-bad-free \
  gstreamer1-plugins-ugly

# --------------------------------------------------
# Hardware video acceleration
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
echo "🎮 Installing gaming multimedia support"

sudo dnf install -y \
  steam-devices \
  pipewire-jack-audio-connection-kit \

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
echo "🧹 Cleaning up"

sudo dnf autoremove -y
sudo dnf clean all

echo "✅ RPM Fusion & multimedia setup complete"
