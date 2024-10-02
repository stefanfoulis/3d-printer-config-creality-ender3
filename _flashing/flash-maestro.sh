set -euo pipefail

sudo service klipper stop

pushd ~/klipper

# === Duet2 Maestro MCU ===
export CFG=maestro
export DEV=/dev/serial/by-id/usb-Klipper_sam4s8c_00313853314E57313235303135303538-if00
# export DEV=/dev/ttyACM0
# export DEV=/dev/serial/by-id/usb-03eb_6124-if00

echo "[${CFG}] compiling"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ clean
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ all
echo "[${CFG}] flashing"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out-${CFG}/ FLASH_DEVICE=${DEV} flash


popd
sudo service klipper start