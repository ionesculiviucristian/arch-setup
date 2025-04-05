#!/bin/bash
set -eu

sudo -v

sudo pacman -Syu

# ==========================================
# Install Flatpak packages
# ==========================================

flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.getpostman.Postman
flatpak install -y flathub com.spotify.Client
