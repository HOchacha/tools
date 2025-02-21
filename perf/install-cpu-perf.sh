#!/bin/bash

set -e
set -x

echo "⚙️ Installing CPU Performance Test Tools..."
sudo apt update -y
sudo apt install -y sysbench stress-ng

# UnixBench 설치
git clone https://github.com/kdlucas/byte-unixbench.git ~/unixbench
cd ~/unixbench
make

echo "✅ CPU Performance Test Tools installed successfully."