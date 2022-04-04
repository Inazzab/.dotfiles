#!/bin/bash

#Install yay
sudo pacman -Syu --needed base-devel git
cd ~
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si

#Enable arch repos
yay -S artix-archlinux-support
cp ~/.dotfiles/pacman.conf /etc/pacman.conf
pacman-key --populate archlinux

yay -S brave librewolf bitwarden neovim neovim-plug onlyoffice nvidia xmonad xmonad-contrib
cd .config && mkdir nvim
cp ~/.dotfiles/init.vim .config/nvim/init.vim
ntpd -qg #Resynchronizes clock in case of timezone issues when dual booting w/windows
