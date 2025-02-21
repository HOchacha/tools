#!/bin/bash

set -e  # 오류 발생 시 즉시 종료
set -x  # 실행되는 명령어 출력 (디버깅용)

LLVM_VERSION=${LLVM_VERSION:-13}  # 설치할 LLVM 및 Clang 버전

echo "Target LLVM version: ${LLVM_VERSION}"

if [[ -z LLVM_VERSION ]] 

    return
fi 

echo "Checking installed LLVM and Clang versions..."
dpkg -l | grep llvm || echo "No existing LLVM installation found."
dpkg -l | grep clang || echo "No existing Clang installation found."

echo "Removing existing LLVM and Clang versions..."
sudo apt remove --purge -y clang-* llvm-* || echo "No LLVM/Clang found to remove."
sudo apt autoremove -y

echo "Downloading LLVM installation script..."
wget -q https://apt.llvm.org/llvm.sh -O llvm.sh

echo "Setting execution permissions..."
chmod +x llvm.sh

echo "Installing LLVM $LLVM_VERSION..."
sudo ./llvm.sh $LLVM_VERSION

echo "Updating package list..."
sudo apt update -y

echo "Installing Clang and LLVM $LLVM_VERSION..."
sudo apt install -y clang-$LLVM_VERSION llvm-$LLVM_VERSION llvm-$LLVM_VERSION-dev llvm-$LLVM_VERSION-tools

echo "Verifying installation paths..."
if [[ ! -f "/usr/bin/clang-$LLVM_VERSION" ]] || [[ ! -f "/usr/bin/clang++-$LLVM_VERSION" ]] || [[ ! -f "/usr/bin/llvm-config-$LLVM_VERSION" ]]; then
    echo "Error: One or more required binaries are missing. Exiting."
    exit 1
fi

echo "Setting default alternatives for LLVM and Clang..."
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$LLVM_VERSION 100
sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION 100

echo "Manually configuring alternatives..."
sudo update-alternatives --config clang
sudo update-alternatives --config clang++
sudo update-alternatives --config llvm-config

echo "Verifying installed versions..."
clang --version || { echo "Clang installation failed!"; exit 1; }
clang++ --version || { echo "Clang++ installation failed!"; exit 1; }
llvm-config --version || { echo "LLVM Config installation failed!"; exit 1; }

echo "LLVM and Clang $LLVM_VERSION setup completed successfully!"