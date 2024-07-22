source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
export _JAVA_AWT_WM_NONREPARENTING=1
exec slstatus 2>&1 >/dev/null &
exec dwm
