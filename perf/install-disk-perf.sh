#!/bin/bash

set -e
set -x

echo "📂 Installing File Performance Test Tools..."
sudo apt update -y
sudo apt install -y fio bonnie++ iozone3 hdparm

echo "✅ File Performance Test Tools installed successfully."