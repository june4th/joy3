#!/bin/bash
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
device_name=$(getprop ro.product.model)
echo "Setup CCminer for RIG NAME: $device_name"
echo "Enter POOL ADDRESS:"
read pool_address
echo "Enter WALLET ADDRESS:"
read wallet_address
config_content="{\"pools\": [{\"name\": \"AUTO-NICEHASH\",\"url\": \"$pool_address\",\"timeout\": 180,\"disabled\": 0}],\"user\": \"$wallet_address.${device_name}\",\"pass\": \"x\",\"algo\": \"verus\",\"threads\": 8,\"cpu-priority\": 1,\"cpu-affinity\": -1,\"retry-pause\": 10}"
echo "$config_content" | tee ~/ccminer/config.json
echo "config.json was updated."
echo "setup nearly complete."
echo "Edit the config with \"nano ~/ccminer/config.json\""
echo "start the miner with \"cd ~/ccminer; ./start.sh\"."
