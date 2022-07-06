
#!/bin/sh


echo -e "\033[1;33m"
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
echo -e "\033[1;33m"
echo "Telegram : @Paperhang                                ";
echo "Twitter  : @rehan_ssf                                ";
echo -e "\e[0m"
sleep 2
echo
# Set Vars
if [ ! $NODENAME ]; then
	read -p "NODENAME 👉  : " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
SEI_PORT=12
if [ ! $WALLET ]; then
    read -p "NAME WALLET 👉  : " WALLET
	echo "export WALLET=$WALLET" >> $HOME/.bash_profile
fi
echo "export SEI_CHAIN_ID=sei-testnet-2" >> $HOME/.bash_profile
echo "export SEI_PORT=${SEI_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
echo
echo '||================INFO===================||'
echo
echo -e "YOU NODE NAME : \e[1m\e[32m$NODENAME\e[0m"
echo -e "YOU WALLET NAME : \e[1m\e[32m$WALLET\e[0m"
echo -e "YOU CHAIN ID : \e[1m\e[32m$SEI_CHAIN_ID\e[0m"
sleep 2
echo
echo -e "\e[1m\e[31m[+] Update && Dependencies... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y
echo
sudo apt install curl build-essential git wget jq make gcc tmux -y
echo
# install go
wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
sudo tar -xvf go1.18.3.linux-amd64.tar.gz
sudo mv go /usr/local
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
echo
echo -e "\e[1m\e[31m[+] build binary... \e[0m" && sleep 1
echo
# download binary
cd $HOME
rm -rf sei-chain
git clone https://github.com/sei-protocol/sei-chain.git
cd sei-chain
git checkout 1.0.6beta
make install
seid version

# replace nodejumper with your own moniker, if you'd like
seid init $NODENAME --chain-id sei-testnet-2 -o

curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/genesis.json > ~/.sei/config/genesis.json
sha256sum $HOME/.sei/config/genesis.json

curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/addrbook.json > ~/.sei/config/addrbook.json
sha256sum $HOME/.sei/config/addrbook.json

sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001usei"|g' $HOME/.sei/config/app.toml
SEEDS=""
PEERS="a31a25a812e13bbbe58a58c14db3cd529c4f870d@3.15.197.187:26656,5b5ec09067a5fcaccf75f19b45ab29ce07e0167c@18.118.159.154:26656,20528d7ab115e56660b06fbff1b95c543e19e2e3@194.163.150.25:26256,49e9d66477cd5df48ceb884b6870cccfc5fa96c5@47.156.153.124:56656,ddb046d461bd698bf2b5f0608bc9ed9ebb69821b@20.46.229.243:12656,44c4e0294f6912b130f57a0fddc5d7434b68ca37@65.108.7.120:26656,3ddc21e72f88e1d83ff2098d25fb6988f59598fa@38.242.250.253:26656,a50a2c2a39e740e18e2a3810867ce8786d64f718@75.119.155.73:12656,591b797c0a4af6d3decaaf0f14dab8ce92d7c3ae@51.120.95.14:12656,f161690e4f552194097b3e99501a526c8862c03c@20.38.38.1:12656,b1bab63a99b58cdc05e015875e426bc28eb9716c@149.102.143.141:12656,b6e9a99fb9a960fa71d36f0c9b442c2b9fba9484@51.120.1.230:12656,c89a26cf8d4812fb8873f6e46bead2363f8ab67c@147.182.203.5:12656,52517312816bf4c6ab1d99fc347647b4626064e7@52.155.104.204:26656,7886e2704b892ed032ff5091e41542216309f39c@20.249.4.115:12656,59bbe8e365c56e29ccd1d88462fe92c43bc8e173@89.163.143.208:26656,a3f055c2cd623d9d1353d8c6566b9d00e01ef0be@13.87.71.97:12656,51213fb34076bd39d7f687ea94deb6916301d118@20.118.224.134:12656,93578f85728acfc14f8d9c1f84f7d8d0548cfd15@20.40.89.41:12656,9c74bdb1f6d34e1eb45b6810e116e8033b2d7014@20.119.48.205:12656,dff3c3c5679d06166476773d2ee777b4c6dfd3eb@52.255.136.48:12656,38b4d78c7d6582fb170f6c19330a7e37e6964212@194.163.189.114:46656,1c6b5b7d880e488e87e86b0de420ad92d4cece50@149.102.158.204:12656,edf25610498e0a1192c743f39368502ece89ec8d@144.76.19.103:26656,678580163a228a8240a3d15ee128ad94fe623141@159.89.204.218:12656,cd2ce7465937c046aeefb286744c45afd1b63ebb@139.59.100.192:12656,396f45e6270f34f608ffc1727c2fc0d1955aff3b@137.184.76.160:12656,99c0a0a5bdb19a9b8be05b8f268d6e12a01e6dc3@146.19.24.34:26656,db4fa2ced59020bcec13668b3204a2fd2ac5b720@188.166.228.170:26656,bccab1003dd4f794ad8be49209700129fb86de99@38.242.221.88:26656,d4479d0bf6e543ec60fae27206ec5a70837c555e@38.242.129.240:36376,a452faddaf371e840fcbb0e44c7234551949d1b7@34.66.153.93:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml

# in case of pruning
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.sei/config/app.toml

sudo tee /etc/systemd/system/seid.service > /dev/null << EOF
[Unit]
Description=Sei Protocol Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which seid) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

seid tendermint unsafe-reset-all


SNAP_RPC="http://rpc1-testnet.nodejumper.io:28657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sei/config/config.toml

sudo systemctl daemon-reload
sudo systemctl enable seid
sudo systemctl restart seid


sudo apt update
sudo apt install snapd -y
sudo snap install lz4

sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book

cd $HOME/.sei
rm -rf data

SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/sei-testnet/ | egrep -o ">sei-testnet-2.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/sei-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf -

source $HOME/.bash_profile

sudo systemctl restart seid


echo
echo
echo 'INSTALASI SELESAI  🚀 '
echo
echo -e 'untuk mengecek logs: \e[1m\e[32msudo journalctl -u seid -f --no-hostname -o cat\e[0m'
echo -e "untuk mengecek status sync: \e[1m\e[32mseid status 2>&1 | jq .SyncInfo\e[0m"




