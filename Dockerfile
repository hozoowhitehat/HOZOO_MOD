#!/bin/bash

# Pastikan sistem diperbarui
sudo apt update && sudo apt upgrade -y

# Instal paket yang diperlukan
sudo apt install -y xfce4 xfce4-goodies xrdp novnc websockify pulseaudio dbus-x11 \
    x11-xserver-utils curl wget git unzip

# Konfigurasi NoVNC
mkdir -p /opt/novnc
cd /opt/novnc
git clone https://github.com/novnc/noVNC.git
git clone https://github.com/novnc/websockify.git
cd noVNC
ln -s ../websockify websockify

# Buat skrip untuk menjalankan NoVNC di port 6980
cat <<EOF > /opt/novnc/start-novnc.sh
#!/bin/bash
/opt/novnc/noVNC/utils/launch.sh --vnc localhost:5901 --listen 6980 &
EOF
chmod +x /opt/novnc/start-novnc.sh

# Konfigurasi XRDP
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Setel wallpaper anime
dir_wallpaper="/usr/share/backgrounds"
sudo mkdir -p "$dir_wallpaper"
sudo wget -O "$dir_wallpaper/anime_wallpaper.jpg" "https://c4.wallpaperflare.com/wallpaper/702/677/218/anime-anime-girls-sword-red-fan-art-hd-wallpaper-preview.jpg"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$dir_wallpaper/anime_wallpaper.jpg"

# Instal tema ikon Windows 10
mkdir -p ~/.icons
cd ~/.icons
git clone https://github.com/B00merang-Artwork/Windows-10.git
xfconf-query -c xsettings -p /Net/IconThemeName -s "Windows-10"

# Aktifkan dukungan suara dengan Pulseaudio
sudo systemctl enable pulseaudio
sudo systemctl start pulseaudio

# Jalankan NoVNC saat startup
sudo bash -c 'echo "@reboot root /opt/novnc/start-novnc.sh" >> /etc/crontab'

# Selesai
echo "Instalasi selesai! Akses NoVNC di browser melalui http://IP_SERVER:6980"
