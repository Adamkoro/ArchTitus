#!/bin/bash

# Install apps
flatpak install -y flathub org.gtk.Gtk3theme.Breeze-Dark
flatpak install -y flathub com.teamspeak.TeamSpeak
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.github.wwmm.pulseeffects
flatpak install -y flathub com.spotify.Client

# Setting theme
flatpak override --env=GTK_THEME=Breeze-Dark com.sindresorhus.Caprine
flatpak override --env=GTK_THEME=Breeze-Dark com.github.wwmm.pulseeffects