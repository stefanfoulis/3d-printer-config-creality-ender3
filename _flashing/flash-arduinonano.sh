set -euo pipefail

sudo service klipper stop

pushd ~/klipper

# === Arduino Nano MCU ===
export CFG=arduinonano
export DEV=/dev/serial/by-id/usb-1a86_USB2.0-Ser_-if00-port0
# export DEV=/dev/ttyUSB0

echo "[${CFG}] compiling"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
echo "[${CFG}] flashing"
avrdude -carduino -patmega328p -P${DEV} -b57600 -D -Uflash:w:out-${CFG}/klipper.elf.hex:i


popd
sudo service klipper start


