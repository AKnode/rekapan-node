#!/bin/bash

echo -e "\033[0;34m"
echo "  ▄▄▄       ██ ▄█▀ ███▄    █  ▒█████  ▓█████▄ ▓█████ "; 
echo " ▒████▄     ██▄█▒  ██ ▀█   █ ▒██▒  ██▒▒██▀ ██▌▓█   ▀ "; 
echo " ▒██  ▀█▄  ▓███▄░ ▓██  ▀█ ██▒▒██░  ██▒░██   █▌▒███   "; 
echo " ░██▄▄▄▄██ ▓██ █▄ ▓██▒  ▐▌██▒▒██   ██░░▓█▄   ▌▒▓█  ▄ ";
echo "  ▓█   ▓██▒▒██▒ █▄▒██░   ▓██░░ ████▓▒░░▒████▓ ░▒████▒";
echo "  ▒▒   ▓▒█░▒ ▒▒ ▓▒░ ▒░   ▒ ▒ ░ ▒░▒░▒░  ▒▒▓  ▒ ░░ ▒░ ░";
echo "   ▒   ▒▒ ░░ ░▒ ▒░░ ░░   ░ ▒░  ░ ▒ ▒░  ░ ▒  ▒  ░ ░  ░";
echo "   ░   ▒   ░ ░░ ░    ░   ░ ░ ░ ░ ░ ▒   ░ ░  ░    ░   ";
echo "       ░  ░░  ░            ░     ░ ░     ░       ░  ░";
echo "                                       ░             ";
echo -e "\e[0m"
echo -e "\033[0;32m"
echo "Telegram : @Paperhang                                ";
echo "Twitter  : @rehan_ssf                                ";
echo -e "\e[0m"
sleep 2
echo
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
echo
if grep -q avx2 /proc/cpuinfo; then
	echo ""
else
	echo -e "\e[31mInstallation is not possible, your server does not support AVX2, change your server and try again.\e[39m"
	exit
fi
if ss -tulpen | awk '{print $5}' | grep -q ":80$" ; then
	echo -e "\e[31mInstallation is not possible, port 80 already in use.\e[39m"
	exit
else
	echo ""
fi
if ss -tulpen | awk '{print $5}' | grep -q ":6180$" ; then
	echo -e "\e[31mInstallation is not possible, port 6180 already in use.\e[39m"
	exit
else
	echo ""
fi
if ss -tulpen | awk '{print $5}' | grep -q ":6181$" ; then
	echo -e "\e[31mInstallation is not possible, port 6181 already in use.\e[39m"
	exit
else
	echo ""
fi
if ss -tulpen | awk '{print $5}' | grep -q ":9101$" ; then
	echo -e "\e[31mInstallation is not possible, port 9101 already in use.\e[39m"
	exit
else
	echo ""
fi
if [ ! $APTOS_NODENAME ]; then
read -p "Enter your node name: " APTOS_NODENAME
echo 'export APTOS_NODENAME='\"${APTOS_NODENAME}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
echo "export WORKSPACE=\"$HOME/.aptos\"" >>$HOME/.bash_profile
. $HOME/.bash_profile

apt update && apt install git sudo unzip wget -y
#install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
#install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
 
#install aptos
wget -qO aptos-cli.zip https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-0.2.0/aptos-cli-0.2.0-Ubuntu-x86_64.zip
unzip -o aptos-cli.zip
chmod +x aptos
mv aptos /usr/local/bin 
 
#create folder,download config    
IPADDR=$(curl ifconfig.me) 
sleep 2   
mkdir -p $HOME/.aptos
cd $HOME/.aptos
wget -O $HOME/.aptos/docker-compose.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose.yaml
wget -O $HOME/.aptos/validator.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/validator.yaml
#wget -O fullnode.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/fullnode.yaml

aptos genesis generate-keys --assume-yes --output-dir $HOME/.aptos

aptos genesis set-validator-configuration \
    --keys-dir $HOME/.aptos --local-repository-dir $HOME/.aptos \
    --username $APTOS_NODENAME \
    --validator-host $IPADDR:6180
    
#aptos key generate --assume-yes --output-file root_key.txt
#KEYTXT=$(cat ~/.aptos/root_key.txt.pub) 
#KEY="0x"$KEYTXT 

echo "---
root_key: \"F22409A93D1CD12D2FC92B5F8EB84CDCD24C348E32B3E7A720F3D2E288E63394\"
users:
  - \"$APTOS_NODENAME\"
chain_id: 40
min_stake: 0
max_stake: 100000
min_lockup_duration_secs: 0
max_lockup_duration_secs: 2592000
epoch_duration_secs: 86400
initial_lockup_timestamp: 1656615600
min_price_per_gas_unit: 1
allow_new_validators: true" >layout.yaml
    
wget -O $HOME/.aptos/framework.zip https://github.com/aptos-labs/aptos-core/releases/download/aptos-framework-v0.2.0/framework.zip
unzip -o framework.zip
aptos genesis generate-genesis --assume-yes --local-repository-dir $HOME/.aptos --output-dir $HOME/.aptos
sleep 2
docker-compose down -v
sleep 2
docker compose up -d
echo -e "Your Aptos node \e[32minstalled and works\e[39m!"