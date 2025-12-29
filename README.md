# ASUS Micmute Key LED Driver
This script is created for ASUS Vivobooks which use [asus-nb-wmi](https://github.com/torvalds/linux/blob/master/drivers/platform/x86/asus-nb-wmi.c). This is a kernel module that is included in the Linux kernel and is loaded automatically on ASUS laptops.

## Adjust the script
Change `CARD` and `CONTROL` in `./src/asus-micmute-key-led-driver.sh` values accordingly to your device. For example, check it by:
```bash
sudo amixer -c 1 get Capture
```

## Install/uninstall
```bash
./installer.sh
```

## Sources
This project is based on: [this GitHub repository](https://github.com/Arkapravo-Ghosh/asus-micmute-key-led-driver), and fixes the startup problem.
