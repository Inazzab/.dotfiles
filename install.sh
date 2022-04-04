#!/bin/bash
sudo pacman -Syu --needed base-devel git
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
yay -S brave librewolf bitwarden neovim onlyoffice
