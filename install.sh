#!/bin/bash
sudo pacman -Syu --needed base-devel git
cd ~
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
yay -S brave librewolf bitwarden neovim neovim-plug onlyoffice nvidia
ntpd -qg #Resynchronizes clock in case of timezone issues when dual booting w/windows
