#!/bin/sh


echo -e "\e[1m\e[32m"
echo " 📌 Twitter  : @rehan_ssf"
echo " 📌 Telegram : @paperhang"
echo -e "\e[0m"
echo -n " klik enter aja bang 😂 !"
read user
echo
echo
sudo apt update
sudo apt install snapd -y
sudo snap install lz4

sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book

cd $HOME/.sei
rm -rf data

SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/sei-testnet/ | egrep -o ">sei-testnet-2.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/sei-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf -

sudo systemctl restart seid
sudo journalctl -u seid -f --no-hostname -o cat