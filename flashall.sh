set -euo pipefail

sudo service klipper stop

pushd ~/klipper

# === Duet2 Maestro MCU ===
export CFG=maestro
export DEV=/dev/serial/by-path/platform-3f980000.usb-usb-0:1.2:1.0
echo "[${CFG}] compiling"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
echo "[${CFG}] flashing"
${PWD}/scripts/flash-sdcard.sh -f ${PWD}/out-${CFG}/klipper.bin ${DEV} btt-skr-turbo-v1.4



# === Arduino Nano MCU ===
# export CFG=arduinonano
# export DEV=/dev/serial/by-id/usb-1a86_USB2.0-Ser_-if00-port0
# export DEV=/dev/ttyUSB0
# echo "[${CFG}] compiling"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
# echo "[${CFG}] flashing"
# avrdude -carduino -patmega328p -P${DEV} -b57600 -D -Uflash:w:out-${CFG}/klipper.elf.hex:i


# === Pi Host MCU ===
export CFG=pi
echo "[${CFG}] compiling"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ clean
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ all
echo "[${CFG}] flashing"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ flash


popd
sudo service klipper start


