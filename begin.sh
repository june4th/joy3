#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/june4th/ccminer.git
cd ccminer
chmod +x build.sh configure.sh autogen.sh start.sh
if [ ! -f ~/.bashrc ]; then
  echo "~/ccminer/start.sh" > ~/.bashrc
else
  if ! grep -Fxq "~/ccminer/start.sh" ~/.bashrc; then
    echo "~/ccminer/start.sh" >> ~/.bashrc
  fi
fi
CXX=clang++ CC=clang ./build.sh
nano ~/ccminer/config.json
