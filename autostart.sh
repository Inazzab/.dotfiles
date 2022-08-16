#!/bin/bash
picom --vsync &
xrandr --output HDMI-1-0 --mode 2560x1440 &
emacs --daemon &
lxpolkit &
