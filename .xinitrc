#!/bin/sh
xrdb -merge ~/.Xresources

setxkbmap -option caps:numlock

nm-applet &
blueman-applet &

(
	until i3-msg -t get_workspaces; do sleep 0.1; done
	i3-msg 'workspace 1;  exec firefox'
	i3-msg 'workspace 2;  exec kitty -e tmux-init'
	i3-msg 'workspace 10; exec anki'
) &


[ -f .user.xinitrc ] && . ~/.user.xinitrc

exec i3
