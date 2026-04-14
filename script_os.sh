#!/bin/bash

set -e

echo 'Installing XRDP + XFCE (OpenSUSE Leap 15.6) - Improved'
echo '======================================================='

echo ''
echo 'Step 1: Updating system packages'
sudo zypper refresh
sudo zypper update -y

echo ''
echo 'Step 2: Installing XRDP + Xorg backend'
sudo zypper install -y xrdp xorgxrdp

echo ''
echo 'Step 3: Installing XFCE desktop environment'
sudo zypper install -y xfce4-panel xfce4-session xfce4-settings xfwm4 xfdesktop xfce4-terminal

echo ''
echo 'Step 4: Configuring XFCE session'
echo xfce4-session > ~/.Xclients
chmod +x ~/.Xclients

if [ -f /etc/xrdp/startwm.sh ]; then
  sudo sed -i 's#.*startwm.*#startxfce4#' /etc/xrdp/startwm.sh
  echo 'XFCE session configured in startwm.sh'
fi

echo ''
echo 'Step 5: Enabling and starting XRDP service'
sudo systemctl enable xrdp
sudo systemctl restart xrdp
sudo systemctl status xrdp --no-pager

echo ''
echo 'Step 6: Configuring firewall for RDP (port 3389)'

# Check which firewall is running
if systemctl is-active --quiet firewalld; then
  echo 'Firewalld is active - configuring with firewall-cmd'
  sudo firewall-cmd --permanent --add-port=3389/tcp || true
  sudo firewall-cmd --reload || true
  echo 'Port 3389 opened via firewalld'
  
elif systemctl is-active --quiet SuSEfirewall2; then
  echo 'SuSEfirewall2 is active - configuring firewall rules'
  sudo sed -i '/^FW_SERVICES_EXT_TCP=/s/"$/ 3389"/' /etc/sysconfig/SuSEfirewall2 || true
  sudo systemctl restart SuSEfirewall2
  echo 'Port 3389 opened via SuSEfirewall2'
  
else
  echo 'Warning: No recognized firewall service detected'
  echo 'Manually configure firewall to allow port 3389/tcp for XRDP'
fi

echo ''
echo '======================================================='
echo 'Installation complete!'
echo 'XRDP is ready on port 3389'
echo 'You can now connect via Remote Desktop to this system'
echo ''
echo 'To verify XRDP is running:'
echo '  sudo systemctl status xrdp'
echo ''
echo 'To check firewall status:'
echo '  sudo firewall-cmd --list-ports (if using firewalld)'
echo '  sudo grep FW_SERVICES_EXT_TCP /etc/sysconfig/SuSEfirewall2 (if using SuSEfirewall2)'
