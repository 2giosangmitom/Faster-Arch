#!/usr/bin/bash

# Intel driver
echo -e "\n\033[1;31mInstall intel-media-driver...\n\033[0m"
sudo pacman -S intel-media-driver --noconfirm --needed
echo -e "\n\033[1;31mInstall intel-media-sdk...\n\033[0m"
sudo pacman -S intel-media-sdk --noconfirm --needed

# Install paccache
echo -e "\n\033[1;31mInstall pacman-contrib...\n\033[0m"
sudo pacman -S pacman-contrib --noconfirm --needed

# Install linux-zen kernel
echo -e "\n\033[1;31mInstall linux-zen...\n\033[0m"
sudo pacman -S linux-zen --noconfirm --needed

# Install dbus-broker
echo -e "\n\033[1;31mInstall dbus-broker...\n\033[0m"
sudo pacman -S dbus-broker --noconfirm --needed
sudo systemctl enable dbus-broker.service

# Install earlyoom
echo -e "\n\033[1;31mInstall earlyoom...\n\033[0m"
sudo pacman -S earlyoom --noconfirm --needed
sudo systemctl enable --now earlyoom

# Disable some services
sudo systemctl mask systemd-random-seed
sudo systemctl mask lvm2-monitor

# Blacklist
sudo cp ./blacklist.conf /etc/modprobe.d/

# Disable journald
sudo sed -E -i 's/#Storage=auto/Storage=none/' /etc/systemd/journald.conf

# Clean pacman cache
[[ -n $(pacman -Qdt) ]] && sudo pacman -Rns $(pacman -Qdtq) || echo "No orphaned packages to remove!"
paccache --remove --keep 1
paccache --remove --uninstalled --keep 0

echo -e "\n\033[1;32mFinished! Reboot and enjoy\033[0m"
