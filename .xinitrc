#!/bin/sh
xrdb -merge ~/.Xresources

setxkbmap -option caps:numlock

nm-applet &
blueman-applet &

exec i3
