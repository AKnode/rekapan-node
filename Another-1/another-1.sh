
#!/bin/sh


echo -e "\033[1;34m"
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
echo -e "\033[1;32m"
echo "Telegram : @Paperhang                                ";
echo "Twitter  : @rehan_ssf                                ";
echo -e "\e[0m"
sleep 2
echo
# Set Vars
if [ ! $NODENAME ]; then
	read -p "YOUR NODENAME 👉  : " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
    read -p "NAME WALLET 👉  : " WALLET
	echo "export WALLET=$WALLET" >> $HOME/.bash_profile
fi
echo "export ANONE_CHAIN_ID=anone-testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
echo '||================INFO===================||'
echo
echo -e "YOU NODE NAME : \e[1m\e[32m$NODENAME\e[0m"
echo -e "YOU WALLET NAME : \e[1m\e[32m$WALLET\e[0m"
echo -e "YOU CHAIN ID : \e[1m\e[32m$ANONE_CHAIN_ID\e[0m"
sleep 2
echo
echo -e "\e[1m\e[31m[+] Update && Dependencies... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y
echo
sudo apt install -y make gcc jq curl git
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
echo -e "\e[1m\e[31m[+] build binary... \e[0m" && sleep 1
echo
# download binary
cd $HOME
rm -rf anone
git clone https://github.com/notional-labs/anone
cd anone
git checkout testnet-1.0.3
make install 
anoned version
#init
anoned init $NODENAME --chain-id $ANONE_CHAIN_ID

curl https://raw.githubusercontent.com/notional-labs/anone/master/networks/testnet-1/genesis.json > $HOME/.anone/config/genesis.json
sha256sum $HOME/.anone/config/genesis.json

# seeds & peers
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uan1"|g' $HOME/.anone/config/app.toml
seeds=""
peers="2b540c43d640befc35959eb062c8505612b7d67f@rpc1-testnet.nodejumper.io:26656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.anone/config/config.toml

# in case of pruning
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.anone/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.anone/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.anone/config/app.toml

#start service
sudo tee /etc/systemd/system/anoned.service > /dev/null << EOF
[Unit]
Description=Another-1 Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which anoned) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

anoned unsafe-reset-all

SNAP_RPC="http://rpc1-testnet.nodejumper.io:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.anone/config/config.toml

sudo systemctl daemon-reload
sudo systemctl enable anoned
sudo systemctl restart anoned

echo -e 'successful installation'
echo -e 'to check logs: \e[1m\e[32msudo journalctl -u anoned -f --no-hostname -o cat\e[0m'
echo -e "to check sync status: \e[1m\e[32manoned status 2>&1 | jq .SyncInfo\e[0m"