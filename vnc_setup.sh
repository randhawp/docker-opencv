#!/bin/sh
export DISPLAY=:20
Xvfb :20 -screen 0 1366x768x16 &
x11vnc -passwd changeit -display :20 -N -forever &
