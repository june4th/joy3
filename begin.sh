#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/june4th/ccminer-termux.git
cd ccminer-termux
chmod +x build.sh configure.sh autogen.sh start.sh
CXX=clang++ CC=clang ./build.sh
if [ ! -f ~/.bashrc ]; then
  echo "~/ccminer-termux/start.sh" > ~/.bashrc
else
  if ! grep -Fxq "~/ccminer-termux/start.sh" ~/.bashrc; then
    echo "~/ccminer-termux/start.sh" >> ~/.bashrc
  fi
fi
nano config.json
