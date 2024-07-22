#!/bin/bash
echo "Setup CCminer for RIG NAME: "
read device_name < /dev/tty
echo "Enter POOL ADDRESS: " 
read pool_address < /dev/tty
echo "Enter WALLET ADDRESS: " 
read wallet_address < /dev/tty
config_content="{\"pools\": [{\"name\": \"AUTO-NICEHASH\",\"url\": \"$pool_address\",\"timeout\": 180,\"disabled\": 0}],\"user\": \"$wallet_address.${device_name}\",\"pass\": \"x\",\"algo\": \"verus\",\"threads\": 8,\"cpu-priority\": 1,\"cpu-affinity\": -1,\"retry-pause\": 10}"
rm ~/ccminer/config.json
echo "$config_content" > ~/ccminer/config.json
echo "config.json was updated."
