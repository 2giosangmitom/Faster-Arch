package main

import (
	"bufio"
	"fmt"
	"log"
	"os/exec"
)

var (
	Reset  = "\033[0m"
	Red    = "\033[31m"
	Green  = "\033[32m"
	Yellow = "\033[33m"
	Blue   = "\033[34m"
	Purple = "\033[35m"
	Cyan   = "\033[36m"
	Gray   = "\033[37m"
	White  = "\033[97m"
)

// Get real time output
func runCommand(command string) {
	cmd := exec.Command("sh", "-c", command)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	cmd.Start()

	scanner := bufio.NewScanner(stdout)

	for scanner.Scan() {
		m := scanner.Text()
		fmt.Println(m)
	}

	cmd.Wait()
}

func install_intel_driver() {
	fmt.Println(Cyan + ">> Install intel driver" + Reset)
	runCommand("sudo pacman -S intel-media-driver --noconfirm --needed")
}

func install_dbus_broker() {
	fmt.Println(Yellow + ">> Install bus_broker" + Reset)
	runCommand("sudo pacman -S dbus-broker --noconfirm --needed")

	fmt.Println(Green + ">> Enable bus-broker service" + Reset)
	runCommand("sudo systemctl enable --now dbus-broker.service")
}

func install_ananicy() {
	fmt.Println(Blue + ">> Install ananicy-cpp" + Reset)
	runCommand("yay -S ananicy-cpp cachyos-ananicy-rules-git --noconfirm --needed")

	fmt.Println(Purple + ">> Enable ananicy-cpp service" + Reset)
	runCommand("sudo systemctl enable --now ananicy-cpp.service")
}

func install_earlyoom() {
	fmt.Println(Red + ">> Install earlyoom" + Reset)
	runCommand("sudo pacman -S earlyoom --noconfirm --needed")

	fmt.Println(Yellow + ">> Enable earlyoom service" + Reset)
	runCommand("sudo systemctl enable --now earlyoom")
}

func disable_some_service() {
	fmt.Println(Cyan + ">> Disable some service" + Reset)
	runCommand("sudo systemctl mask systemd-random-seed")
	runCommand("sudo systemctl mask lvm2-monitor")
}

func disable_journald() {
	fmt.Println(Purple + ">> Disable journald" + Reset)
	runCommand("sudo sed -E -i 's/#Storage=auto/Storage=none/' /etc/systemd/journald.conf")
}

func main() {
	install_intel_driver()
	install_dbus_broker()
	install_ananicy()
	install_earlyoom()
	disable_some_service()
	disable_journald()
}
