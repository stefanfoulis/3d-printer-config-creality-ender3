set -euo pipefail

sudo service klipper stop

pushd ~/klipper


# === Pi Host MCU ===
export CFG=pi
echo "[${CFG}] compiling"
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ clean
# make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ all
echo "[${CFG}] stopping klipper-mcu"
sudo service klipper-mcu stop || true
echo "[${CFG}] flashing"
make KCONFIG_CONFIG=${PWD}/.config-${CFG} OUT=out/ flash
echo "[${CFG}] updating klipper-mcu systemd startup script"
sudo cp "${PWD}/scripts/klipper-mcu.service" /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
echo "[${CFG}] starting klipper_mcu"
sudo systemctl start klipper-mcu.service



popd
sudo service klipper start