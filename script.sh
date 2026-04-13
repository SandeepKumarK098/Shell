#!/bin/bash

echo 'Installing XRDP + XFCE (RHEL 8/9/10)'
sudo dnf -y update || sudo yum -y update

echo 'Installing epel-release'
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %{rhel}).noarch.rpm || true

echo 'Installing XRDP + Xorg backend'
sudo dnf -y install xrdp xorgxrdp || sudo yum -y install xrdp xorgxrdp

echo 'Installing XFCE desktop'
if [[ $(rpm -E %{rhel}) -ge 9 ]]; then
  sudo dnf -y install xfce4-panel xfce4-session xfce4-settings xfwm4 xfdesktop xfce4-terminal
else
  sudo dnf -y groupinstall 'Xfce' || sudo yum -y groupinstall 'Xfce'
fi

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