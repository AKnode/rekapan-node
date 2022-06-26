#!/bin/sh


echo -e "\e[1m\e[32m"
echo " 📌 Twitter  : @rehan_ssf"
echo " 📌 Telegram : @paperhang"
echo -e "\e[0m"
echo -n " klik enter aja bang 😂 !"
read user
echo
echo
sudo systemctl stop dewebd
dewebd unsafe-reset-all

cd $HOME/.deweb
rm -rf data

SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/dws-testnet/ | egrep -o ">deweb-testnet-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/dws-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf -

sudo systemctl restart dewebd
sudo journalctl -u dewebd -f --no-hostname -o cat