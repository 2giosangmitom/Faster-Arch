#!/usr/bin/bash

NOCOLOR="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
GRAY="\033[37m"
WHITE="\033[97m"

echo -e "$WHITE>> Update system$NOCOLOR"
sudo pacman -Syu

echo -e "$CYAN>> Install intel driver$NOCOLOR"
sudo pacman -S intel-media-driver --noconfirm --needed

echo -e "$YELLOW>> Install dbus_broker$NOCOLOR"
sudo pacman -S dbus-broker --noconfirm --needed
echo -e "$GREEN>> Enable dbus-broker service$NOCOLOR"
sudo systemctl enable --now dbus-broker.service

echo -e "$BLUE>> Install ananicy-cpp$NOCOLOR"
yay -S ananicy-cpp cachyos-ananicy-rules-git --noconfirm --needed
echo -e "$PURPLE>> Enable ananicy-cpp service$NOCOLOR"
sudo systemctl enable --now ananicy-cpp.service

echo -e "$RED>> Install earlyoom$NOCOLOR"
sudo pacman -S earlyoom --noconfirm --needed
echo -e "$YELLOW>> Enable earlyoom service$NOCOLOR"
sudo systemctl enable --now earlyoom

echo -e "$CYAN>> Disable some service$NOCOLOR"
sudo systemctl mask systemd-random-seed
sudo systemctl mask lvm2-monitor

echo -e "$PURPLE>> Disable journald$NOCOLOR"
sudo sed -E -i 's/#Storage=auto/Storage=none/' /etc/systemd/journald.conf

echo -e "$WHITE>> Setup auto cleanup cache$NOCOLOR"
sudo pacman -S pacman-contrib --noconfirm --needed
[[ -n $(pacman -Qdt) ]] && sudo pacman -Rns $(pacman -Qdtq) --noconfirm || echo "No orphaned packages to remove!"
paccache --remove --keep 1
paccache --remove --uninstalled --keep 0
sudo systemctl enable --now paccache.timer
