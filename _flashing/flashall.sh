set -euo pipefail

sudo service klipper stop

pushd ~/klipper

# === Duet2 Maestro MCU ===
export CFG=maestro
export DEV=/dev/serial/by-id/usb-Klipper_sam4s8c_00313853314E57313235303135303538-if00
# export DEV=/dev/ttyACM0
# export DEV=/dev/serial/by-id/usb-03eb_6124-if00

# echo "[${CFG}] compiling"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
# echo "[${CFG}] flashing"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ FLASH_DEVICE=${DEV} flash


# === Arduino Nano MCU ===
export CFG=arduinonano
export DEV=/dev/serial/by-id/usb-1a86_USB2.0-Ser_-if00-port0
# export DEV=/dev/ttyUSB0

# echo "[${CFG}] compiling"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
# echo "[${CFG}] flashing"
# avrdude -carduino -patmega328p -P${DEV} -b57600 -D -Uflash:w:out-${CFG}/klipper.elf.hex:i


# === Pi Host MCU ===
export CFG=pi
echo "[${CFG}] compiling"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ clean
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ all
# echo "[${CFG}] stopping klipper_mcu"
# sudo service klipper_mcu stop || true
echo "[${CFG}] flashing"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ flash
echo "[${CFG}] updating klipper_mcu systemd startup script"
sudo cp "${PWD}/scripts/klipper-mcu.service" /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
echo "[${CFG}] starting klipper_mcu"
sudo systemctl start klipper-mcu.service



popd
sudo service klipper start


