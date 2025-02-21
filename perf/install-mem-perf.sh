#!/bin/bash

set -e
set -x

echo "🧠 Installing Memory Performance Test Tools..."
sudo apt update -y
sudo apt install -y sysbench mbw

# MemTest86 다운로드 및 압축 해제
wget -q https://www.memtest86.com/downloads/memtest86-iso.zip -O ~/memtest86.zip
unzip ~/memtest86.zip -d ~/memtest86

# Intel MLC (Memory Latency Checker) 다운로드 및 압축 해제
wget -q https://software.intel.com/content/dam/develop/external/us/en/documents/mlc_v3.9.zip -O ~/mlc.zip
unzip ~/mlc.zip -d ~/mlc

echo "✅ Memory Performance Test Tools installed successfully."