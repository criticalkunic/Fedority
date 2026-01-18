# Fedority
### Fedora KDE Tiling Bootstrap (WIP)

**Fedority** is a **work-in-progress bootstrap for Fedora KDE 43+** focused on delivering a strong **tiling window manager feel inside KDE Plasma**, without abandoning Plasma’s ecosystem or polish.

The goal is a **solid, opinionated out-of-the-box setup** that feels cohesive, fast, and intentional from first login. It is designed for users who want tiling workflows, sane defaults, and minimal manual tweaking, while still benefiting from KDE’s tooling and flexibility.

This project is **inspired by Omarchy**, but adapted specifically for **KDE Plasma on Fedora**, using native tools and conventions where possible.

## What this aims to provide
- A tiling-centric Plasma workflow that feels deliberate and consistent
- Opinionated defaults for window behavior, shortcuts, and layout
- Curated package installs for daily-driver usability
- Sensible KDE configuration applied automatically
- A reproducible setup for fresh Fedora KDE installs

## What this is not (yet?)
- A general-purpose dotfiles repo
- A fully polished or stable release
- Guaranteed safe to run on an existing system

## Requirements
- **Fedora KDE 43+**
- **Fresh installation strongly recommended**
- KDE Plasma session

## Quick install

```bash
git clone https://github.com/criticalkunic/fedority.git \
  && cd fedority \
  && ./bootstrap.sh \
  && cd .. \
  && rm -rf fedority
  && qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
