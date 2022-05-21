#!/bin/bash

#Install yay
sudo pacman -Syu --needed base-devel git
cd ~
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si

#Enable arch repos
yay -S artix-archlinux-support
sudo cp ~/.dotfiles/pacman.conf /etc/pacman.conf
sudo pacman-key --populate archlinux

yay -S brave librewolf bitwarden neovim neovim-plug onlyoffice nvidia xmonad xmonad-contrib dmenu
#Copy nvim config
cd .config && mkdir nvim
cp ~/.dotfiles/init.vim .config/nvim/init.vim

#Copy xmonad config
mkdir .xmonad
cp ~/.dotfiles/xmonad.hs .xmonad/xmonad.hs

ntpd -qg #Resynchronizes clock in case of timezone issues when dual booting w/windows
