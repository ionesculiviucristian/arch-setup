#!/bin/bash
set -eu

sudo -v

sudo pacman -Syu

# ==========================================
# Install Flatpak packages
# ==========================================

flatpak install flathub com.spotify.Client
flatpak install flathub com.getpostman.Postman
