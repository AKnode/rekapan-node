echo -e "\e[1m\e[32m"
echo " 📌 Jangan Lupa di follow biar semangat bantu kalian 😅"
echo " 📌 Twitter  : @rehan_ssf"
echo " 📌 Telegram : @paperhang"
echo -e "\e[0m"
echo " seperti biasa di update dulu ya bang biar gak eror nanti "
echo -n " klik enter aja bang 😂 !"
read user
echo
echo
. ~/.bashrc
if [ ! $MASA_NODENAME ]; then
	read -p "\e[1m\e[32m Masukkan node name\e[0m: " MASA_NODENAME
	echo 'export MASA_NODENAME='$MASA_NODENAME >> $HOME/.bash_profile
	source ~/.bash_profile
fi
echo
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Install pendukung.. \e[0m" && sleep 1
echo
sudo apt install curl build-essential git wget jq make gcc tmux -y
echo

# install packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y

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

# build binary
cd $HOME && rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0
cd masa-node-v1.0/src
make all
cp $HOME/masa-node-v1.0/src/build/bin/* /usr/local/bin

# init
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json

# load bootnodes
cd $HOME
wget https://raw.githubusercontent.com/kj89/testnet_manuals/main/masa/bootnodes.txt
MASA_BOOTNODES=$(sed ':a; N; $!ba; s/\n/,/g' bootnodes.txt)

# create masad service
tee /etc/systemd/system/masad.service > /dev/null <<EOF
[Unit]
Description=MASA
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which geth) \
  --identity ${MASA_NODENAME} \
  --datadir $HOME/masa-node-v1.0/data \
  --bootnodes ${MASA_BOOTNODES} \
  --emitcheckpoints \
  --istanbul.blockperiod 10 \
  --mine \
  --miner.threads 1 \
  --syncmode full \
  --verbosity 5 \
  --networkid 190260 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcvhosts "*" \
  --rpcaddr 127.0.0.1 \
  --rpcport 8545 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --port 30300 \
  --maxpeers 50
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad

# wait before pulling configs
sleep 10

# get node configs
MASA_NODEKEY=$(cat $HOME/masa-node-v1.0/data/geth/nodekey)
MASA_ENODE=$(geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo.enode | sed 's/^.//;s/.$//')

echo -e "\e[1m\e[32mInstalling Massa \e[0m"
echo "=================================================="
echo -e "node name: \e[32m$MASA_NODENAME\e[39m"
echo -e "enode: \e[32m$MASA_ENODE\e[39m"
echo -e "node key: \e[32m$MASA_NODEKEY\e[39m"
echo "=================================================="

echo -e "\e[1m\e[32mUntuk membuka geth: \e[0m" 
echo -e "\e[1m\e[39mgeth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc \n \e[0m" 
echo
echo
echo
echo 'INSTALASI SELESAI  🚀 '
echo
echo -ne "${lightgreen}\e[1m\e[32mToday is:\t\t\e[0m${red}" `date`; echo ""
echo -e "${lightgreen}\e[1m\e[32mKernel Information: \t\e[0m${red}" "Linux 5.10.0-BSA_OS-amd64 x86_64"
echo -e "\e[1m\e[32mTo view logs: \e[0m" 
echo -e "\e[1m\e[39mjournalctl -u masad -f \n \e[0m" 

echo -e "\e[1m\e[32mTo restart: \e[0m" 
echo -e "\e[1m\e[39msystemctl restart masad.service \n \e[0m" 

echo -e "Silakan backup nodekey anda : \e[32m$MASA_NODEKEY\e[39m"
echo -e "Untuk memulihkan di server lain, masukkan kunci simpul Anda ke dalam \e[32m$HOME/masa-node-v1.0/data/geth/nodekey\e[39m and restart service"