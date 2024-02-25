#!/usr/bin/bash

optimize() {
	# Update package repositories
	sudo pacman -Syu

	# Install necessary tools for performance optimization
	sudo pacman -S --noconfirm --needed sysstat thermald linux-zen

	# Enable services
	sudo systemctl enable --now sysstat
	sudo systemctl enable --now thermald
	sudo systemctl enable --now systemd-oomd

	# Optimize Swappiness
	echo "Setting swappiness to 10"
	echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-swappiness.conf
	sudo sysctl --system

	# Disable unnecessary services
	sudo systemctl mask systemd-random-seed
	sudo systemctl mask lvm2-monitor

	# Disable journald
	sudo sed -E -i 's/#Storage=auto/Storage=none/' /etc/systemd/journald.conf

	# Auto cleanup cache
	sudo pacman -S pacman-contrib --noconfirm --needed
	[[ -n $(pacman -Qdt) ]] && sudo pacman -Rns "$(pacman -Qdtq)" --noconfirm || echo "No orphaned packages to remove!"
	paccache --remove --keep 1
	paccache --remove --uninstalled --keep 0
	sudo systemctl enable --now paccache.timer

	# Install ananicy-cpp
	$AUR_HELPER -S ananicy-cpp cachyos-ananicy-rules-git --noconfirm --needed
	sudo systemctl enable --now ananicy-cpp.service
}

main() {
	clear
	cat <<-EOF
		  [*] What is your AUR helper

		  [1] yay
		  [2] paru

	EOF

	read -rp "[?] Select Option : "

	if [[ $REPLY == "1" ]]; then
		AUR_HELPER="yay"
		optimize
	elif [[ $REPLY == "2" ]]; then
		AUR_HELPER="paru"
		optimize
	else
		echo -e "\n[!] Invalid Option, Exiting...\n"
		exit 1
	fi
}

main
