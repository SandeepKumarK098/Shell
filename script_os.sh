#!/bin/bash

echo 'Installing XRDP + XFCE (OpenSUSE Leap 15.6)'
sudo zypper refresh
sudo zypper update -y

echo 'Installing XRDP + Xorg backend'
sudo zypper install -y xrdp xorgxrdp

echo 'Installing XFCE desktop'
sudo zypper install -y xfce4-panel xfce4-session xfce4-settings xfwm4 xfdesktop xfce4-terminal

echo 'Setting XFCE session'
echo xfce4-session > ~/.Xclients
chmod +x ~/.Xclients

if [ -f /etc/xrdp/startwm.sh ]; then
  sudo sed -i 's#.*startwm.*#startxfce4#' /etc/xrdp/startwm.sh
fi

echo 'Enable & start xrdp service'
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo 'Opening RDP firewall port'
sudo firewall-cmd --permanent --add-port=3389/tcp || true
sudo firewall-cmd --reload || true

echo 'Installation complete! XRDP is ready on port 3389'