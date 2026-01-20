#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_DIR="${ROOT_DIR}/apps"

echo "📦 Installing and configuring applications"

echo "Installing RPM Fusion + media stack"
bash "${APPS_DIR}/media.sh"

echo "Installing Application Launcher"
bash "${APPS_DIR}/ulauncher.sh"
