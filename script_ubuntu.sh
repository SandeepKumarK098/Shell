sudo apt update
sudo apt install -y gnome-remote-desktop dbus-x11
sudo loginctl enable-linger nitest
sudo -u nitest dbus-launch gsettings set org.gnome.desktop.remote-desktop.rdp enable true
sudo -u nitest dbus-launch gsettings set org.gnome.desktop.remote-desktop.rdp view-only false
sudo -u nitest dbus-launch gsettings set org.gnome.desktop.remote-desktop.rdp screen-share-mode 'extend'
sudo ufw allow 3389/tcp
