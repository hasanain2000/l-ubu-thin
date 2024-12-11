#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update

# Install Remmina
echo "Installing Remmina..."
sudo apt install -y remmina

# Ask for the RDP server IP address
echo "Please enter the RDP server IP address:"
read rdp_ip

# Set up the Remmina connection profile
profile_dir="/home/jaf/.local/share/remmina"
profile_file="rdp.remmina"

# Ensure the profile directory exists
mkdir -p "$profile_dir"

# Create the Remmina connection profile
echo "Creating Remmina connection profile at $profile_dir/$profile_file..."
cat <<EOL > "$profile_dir/$profile_file"
[remmina]
password=
gateway_username=
notes_text=
vc=
window_width=0
window_height=0
preferipv6=0
ssh_tunnel_loopback=0
serialname=
tls-seclevel=
freerdp_log_level=INFO
printer_overrides=
name=Quick Connect
console=0
colordepth=99
security=
precommand=
disable_fastpath=0
left-handed=0
postcommand=
multitransport=1
group=
server=$rdp_ip
ssh_tunnel_certfile=
glyph-cache=0
ssh_tunnel_enabled=0
disableclipboard=0
disconnect-prompt=0
parallelpath=
audio-output=
monitorids=
cert_ignore=1
serialpermissive=0
gateway_server=
protocol=RDP
ssh_tunnel_password=
labels=VM-4
ssh_tunnel_command=
resolution_mode=2
assistance_mode=0
old-license=0
pth=
disableautoreconnect=0
loadbalanceinfo=
clientbuild=
clientname=
resolution_width=0
drive=
relax-order-checks=0
base-cred-for-gw=0
gateway_domain=
network=dynamic
rdp2tcp=
gateway_password=
rdp_reconnect_attempts=
domain=
serialdriver=
restricted-admin=0
multimon=1
serialpath=
exec=
smartcardname=
username=
enable-autostart=1
usb=
profile-lock=0
ssh_tunnel_passphrase=
disablepasswordstoring=0
shareprinter=0
shareparallel=0
quality=0
span=1
viewmode=4
parallelname=
ssh_tunnel_auth=0
keymap=Map Meta Keys
ssh_tunnel_username=
execpath=
shareserial=0
resolution_height=0
rdp_mouse_jitter=No
useproxyenv=0
sharesmartcard=0
freerdp_log_filters=
microphone=
timeout=
ssh_tunnel_privatekey=
gwtransp=http
ssh_tunnel_server=
ignore-tls-errors=1
window_maximize=1
dvc=
gateway_usage=0
disable-smooth-scrolling=0
no-suppress=0
sound=on
websockets=0
EOL

echo "Remmina connection profile created successfully."

# Change ownership of the Remmina profile
echo "Changing ownership of Remmina profile..."
sudo chown jaf:jaf /home/jaf/.local/share/remmina/rdp.remmina

# Clean up unwanted .desktop files on the Desktop
desktop_dir="/home/jaf/Desktop"
echo "Removing unwanted .desktop files from the Desktop..."
rm -f "$desktop_dir/computer.desktop" "$desktop_dir/lubuntu-manual.desktop" "$desktop_dir/user-home.desktop" "$desktop_dir/trash-can.desktop" "$desktop_dir/network.desktop"

# Create desktop shortcuts
mkdir -p "$desktop_dir"

# Create Reboot shortcut
echo "Creating Reboot desktop shortcut..."
cat <<EOL > "$desktop_dir/Reboot.desktop"
[Desktop Entry]
Name=Reboot
Comment=Reboot the system
Exec=sudo reboot
Icon=system-reboot
Terminal=false
Type=Application
EOL

# Create Shutdown shortcut
echo "Creating Shutdown desktop shortcut..."
cat <<EOL > "$desktop_dir/Shutdown.desktop"
[Desktop Entry]
Name=Shutdown
Comment=Shutdown the system
Exec=sudo shutdown -h now
Icon=system-shutdown
Terminal=false
Type=Application
EOL

# Create Remmina shortcut
echo "Creating Remmina desktop shortcut..."
cat <<EOL > "$desktop_dir/Remmina.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=Quick Connect
Exec=remmina -c /home/jaf/.local/share/remmina/rdp.remmina
Icon=remmina
Terminal=false
Categories=Network;RemoteAccess;
EOL

# Make the desktop shortcuts executable
chmod +x "$desktop_dir/Reboot.desktop" "$desktop_dir/Shutdown.desktop" "$desktop_dir/Remmina.desktop"

# Change ownership of the files and directories
echo "Changing ownership of files in /home/jaf..."
sudo chown -R jaf:jaf /home/jaf

# Allow shutdown and reboot without requiring sudo
echo "Allowing shutdown and reboot without requiring sudo..."
echo "jaf ALL=(ALL) NOPASSWD: /sbin/shutdown, /sbin/reboot" | sudo tee -a /etc/sudoers

# Create AutoStart entry for Remmina inside LXQt session settings
echo "Creating LXQt AutoStart entry for Remmina..."
autostart_dir="/home/jaf/.config/autostart"
mkdir -p "$autostart_dir"

# Create the LXQt AutoStart .desktop file for Remmina
cat <<EOL > "$autostart_dir/remmina.desktop"
[Desktop Entry]
Type=Application
Exec=/usr/bin/remmina -c /home/jaf/.local/share/remmina/rdp.remmina
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Remmina
Comment=Start Remmina on login
EOL

# Done
echo "Setup complete! Remmina and desktop shortcuts are ready, and Remmina will start automatically on login."
