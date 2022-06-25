#!/bin/sh


echo -e "\e[1m\e[32m"
echo " 📌 Jangan Lupa di follow biar semangat bantu kalian 😅"
echo " 📌 Twitter  : @rehan_ssf"
echo " 📌 Telegram : @paperhang"
echo -e "\e[0m"
echo " seperti biasa di update dulu ya bang biar gak eror nanti "
echo -n " klik enter aja bang 😂 !"
read user
echo
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Install pendukung.. \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install make clang pkg-config libssl-dev build-essential git jq llvm libudev-dev -y
echo
echo -e "\e[1m\e[32m3. Install ... \e[0m" && sleep 1
echo
# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
echo