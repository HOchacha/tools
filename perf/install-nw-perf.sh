#!/bin/bash

set -e
set -x

echo "🌐 Installing Network Performance Test Tools..."
sudo apt update -y
sudo apt install -y netperf iperf3 nuttcp wrk 

# Sockperf 설치
git clone https://github.com/Mellanox/sockperf.git ~/sockperf
cd ~/sockperf
./autogen.sh
./configure
make
sudo make install

echo "✅ Network Performance Test Tools installed successfully."