
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
echo "export SEI_CHAIN_ID=sei-devnet-1" >> $HOME/.bash_profile
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
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[31m[+] building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/sei-protocol/sei-chain.git && cd sei-chain
git checkout 1.0.6beta
make install 

# config
seid config chain-id $SEI_CHAIN_ID
seid config keyring-backend test
seid config node tcp://localhost:${SEI_PORT}657

# init
seid init $NODENAME --chain-id $SEI_CHAIN_ID

# download genesis and addrbook
wget -qO $HOME/.sei/config/genesis.json "https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-devnet-1/genesis.json"
wget -qO $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-devnet-1/addrbook.json"

# set peers and seeds
SEEDS="6a600e44396aafa3f64c73e0eb311f0e8454dd57@sei-testnet-2.seed.rhinostake.com:16659"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${SEI_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${SEI_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${SEI_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${SEI_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${SEI_PORT}660\"%" $HOME/.sei/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${SEI_PORT}317\"%; s%^address = \":8080\"%address = \":${SEI_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${SEI_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${SEI_PORT}091\"%" $HOME/.sei/config/app.toml

# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.sei/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.sei/config/app.toml

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0usei\"/" $HOME/.sei/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.sei/config/config.toml

# reset
seid tendermint unsafe-reset-all --home $HOME/.sei

echo -e "\e[1m\e[[31m[+] Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/seid.service > /dev/null <<EOF
[Unit]
Description=sei
After=network-online.target
[Service]
User=$USER
ExecStart=$(which seid) start --home $HOME/.sei
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei

wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-devnet-1/addrbook.json"

SNAP_RPC="http://116.203.35.46:36657"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.sei/config/config.toml
sudo systemctl restart seid && journalctl -u seid -f -o cat

# start service
sudo systemctl daemon-reload
sudo systemctl enable seid
sudo systemctl restart seid


echo
echo
echo -e "Your SEI node \e[32minstalled and works\e[39m!"
echo -e 'untuk mengecek logs: \e[1m\e[32msudo journalctl -u seid -f --no-hostname -o cat\e[0m'
echo -e "untuk mengecek status sync: \e[1m\e[32mseid status 2>&1 | jq .SyncInfo\e[0m"




