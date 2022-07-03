
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
QUICKSILVER_PORT=11
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
echo -e "YOU NODE NAME : \e[1m\e[34m$NODENAME\e[0m"
echo -e "YOU WALLET NAME : \e[1m\e[34m$WALLET\e[0m"
echo -e "YOU CHAIN ID : \e[1m\e[34m$SEI_CHAIN_ID\e[0m"
sleep 2
echo
echo -e "\e[1m\e[31m[+] Update && Dependencies... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y
echo
sudo apt install -y make gcc jq curl git

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

echo -e "\e[1m\e[31m[+] build binary... \e[0m" && sleep 1
echo
# download binary
cd || return
rm -rf sei-chain
git clone https://github.com/sei-protocol/sei-chain.git
cd sei-chain || return
git checkout 1.0.5beta
make install
seid version # 1.0.5beta

# config
seid config chain-id $SEI_CHAIN_ID
seid init $NODENAME --chain-id $SEI_CHAIN_ID -o

# download genesis and addrbook
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/genesis.json > ~/.sei/config/genesis.json
sha256sum $HOME/.sei/config/genesis.json
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/addrbook.json > ~/.sei/config/addrbook.json
sha256sum $HOME/.sei/config/addrbook.json

# set peers and seeds
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001usei"|g' $HOME/.sei/config/app.toml
seeds=""
peers="6a60f171e8b0c0f0c6a0e5cebd6d3d340764c2f5@rpc1-testnet.nodejumper.io:28656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.sei/config/config.toml

# config pruning
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.sei/config/app.toml\

echo -e "\e[1m\e[31m[+] Starting service... \e[0m" && sleep 1
# create service
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

# reset
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book

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
sudo systemctl restart seid && sleep 1

source $HOME/.bash_profile

echo
echo 'INSTALASI SELESAI  🚀 '
echo
echo -e 'untuk mengecek logs: \e[1m\e[32msudo journalctl -u seid.service -f -o cat\e[0m'
echo -e "untuk mengecek status sync: \e[1m\e[32mseid status 2>&1 | jq .SyncInfo\e[0m"




