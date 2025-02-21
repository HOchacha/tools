#!/bin/bash

set -e  # 스크립트 실행 중 에러 발생 시 중단
set -x  # 실행되는 명령어 출력 (디버깅용)

echo "Updating package list..."
sudo apt update -y

echo "Installing required packages..."
sudo apt install -y clang llvm libelf-dev libpcap-dev build-essential libc6-dev-i386

echo "Installing required Linux Packages"
sudo apt install -y linux-tools-$(uname -r) linux-headers-$(uname -r)
sudo apt install -y linux-tools-common linux-tools-generic
sudo apt install -y tcpdump binutils-dev libcap-dev iproute2

echo "Cloning bpftool repository..."
git clone --recurse-submodules https://github.com/libbpf/bpftool.git ~/bpftool

echo "Building and installing bpftool..."
cd ~/bpftool/src/
sudo make install

echo "Cleaning up..."
cd ~
sudo rm -rf ~/bpftool

echo "BPF environment setup completed!"
