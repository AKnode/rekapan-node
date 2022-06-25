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
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz \
&& sudo tar -xvf go1.18.1.linux-amd64.tar.gz && sudo mv go /usr/local \
&& echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile \
&& source ~/.bash_profile; go version

rm go1.18.1.linux-amd64.tar.gz

git clone https://github.com/sei-protocol/sei-chain.git \
&& cd sei-chain && git checkout 1.0.4beta && make install \
&& seid version