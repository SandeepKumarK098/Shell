#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y xfce4 xfce4-goodies
sudo apt-get install -y xrdp

echo "xfce4-session" > /etc/xrdp/startwm.sh
sudo chown -R xrdp:xrdp /home/xrdp
sudo chown -R xrdp:xrdp /var/run/xrdp

sudo systemctl start xrdp
sudo systemctl enable xrdp

sudo ufw allow 3389/tcp 2>/dev/null || true

echo "XRDP installation complete. Connect to port 3389."
