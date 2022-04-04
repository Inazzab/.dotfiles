#!/bin/bash
sudo pacman -Syu --needed base-devel git
cd ~
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
yay -S brave librewolf bitwarden neovim neovim-plug onlyoffice nvidia
cd .config && mkdir nvim
cp ~/.dotfiles/init.vim .config/nvim/init.vim
ntpd -qg #Resynchronizes clock in case of timezone issues when dual booting w/windows
