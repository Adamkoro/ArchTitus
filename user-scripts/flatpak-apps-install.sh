#!/bin/bash

# Install apps
sudo flatpak install -y flathub org.gtk.Gtk3theme.Breeze-Dark
sudo flatpak install -y flathub com.teamspeak.TeamSpeak
sudo flatpak install -y flathub com.discordapp.Discord
#sudo flatpak install -y flathub com.github.wwmm.pulseeffects
#sudo flatpak install -y flathub com.spotify.Client

# Setting theme
sudo flatpak override --env=GTK_THEME=Breeze-Dark com.sindresorhus.Caprine
#sudo flatpak override --env=GTK_THEME=Breeze-Dark com.github.wwmm.pulseeffects
