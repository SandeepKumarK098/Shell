#!/bin/bash

echo "Updating repositories..."
sudo zypper refresh

echo "Installing XRDP and XFCE..."
sudo zypper --non-interactive install xrdp patterns-xfce-xfce

echo "Setting XFCE session..."
echo xfce4-session > ~/.xsession

echo "Configuring XRDP to use XFCE..."
sudo sed -i 's/.*startwm.*/startxfce4/' /etc/xrdp/startwm.sh

echo "Enabling and restarting XRDP service..."
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo "Configuring firewall for RDP (port 3389)..."
sudo firewall-cmd --permanent --add-port=3389/tcp || true
sudo firewall-cmd --reload || true

echo "Setup complete!"
