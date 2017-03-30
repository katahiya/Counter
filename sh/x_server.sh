#!/bin/sh
Xvfb :1 -screen 0 1024x768x24 > /dev/null &
firefox -display :1 -width 1024 -height 800 > /dev/null &
sudo ln -s /usr/local/src/geckodriver/target/release/geckodriver  ~/.rbenv/shims/
