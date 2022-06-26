
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
echo
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Install pendukung.. \e[0m" && sleep 1
echo
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install make clang pkg-config libssl-dev build-essential git jq llvm libudev-dev -y
echo
echo -e "\e[1m\e[32m3. Membuat Moniker... \e[0m" && sleep 1
echo
# set vars
if [ ! $NODENAME ]; then
	read -p "Nama node mu: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
QUICKSILVER_PORT=11
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export SEI_CHAIN_ID=sei-testnet-2" >> $HOME/.bash_profile
echo "export SEI_PORT=${SEI_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '🌀 --------------------------'
echo -e "node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "chain : \e[1m\e[32m$SEI_CHAIN_ID\e[0m"
echo -e "port: \e[1m\e[32m$SEI_PORT\e[0m"
echo '----------------------------🌀'
sleep 2
echo -e "\e[1m\e[32m3. Install ... \e[0m" && sleep 1
# install go
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz \
&& sudo tar -xvf go1.18.1.linux-amd64.tar.gz && sudo mv go /usr/local \
&& echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile \
&& source ~/.bash_profile; go version

rm go1.18.1.linux-amd64.tar.gz

git clone https://github.com/sei-protocol/sei-chain.git \
&& cd sei-chain && git checkout 1.0.4beta && make install \
&& seid version
wget -O $HOME/.sei/config/genesis.json https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/genesis.json 
echo "[Unit]

Description=Seid Node
After=network.target
#
[Service]
User=$USER
Type=simple
ExecStart=$(which seid) start
Restart=on-failure
LimitNOFILE=65535
#
[Install]
WantedBy=multi-user.target" > seid.service \
&& sudo cp seid.service /etc/systemd/system

seid tendermint unsafe-reset-all --home $HOME/.sei

SNAP_RPC1="http://173.212.215.104:26357" \
SNAP_RPC2="http://173.212.215.104:26357"

LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 700)); \
TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sei/config/config.toml

peers="f6c80c797ab4b3161fbf758ed23573c11ea5d559@173.212.215.104:26356"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sei/config/config.toml

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

sudo systemctl enable seid.service
sudo systemctl daemon-reload
sudo systemctl restart seid

sudo systemctl stop seid.service
seid tendermint unsafe-reset-all --home $HOME/.sei

cd $HOME/.sei; rm -rf data wasm
wget http://173.212.215.104/sei-snap-709000.tar   #( 160 MB)
tar xvf sei-snap-709000.tar
wget -q -O $HOME/.sei/config/addrbook.json http://173.212.215.104/addrbook.json
echo
sudo systemctl restart seid.service
echo
echo
echo 'INSTALASI SELESAI  🚀 '
echo
echo -ne "${lightgreen}\e[1m\e[32mToday is:\t\t\e[0m${red}" `date`; echo ""
echo -e "${lightgreen}\e[1m\e[32mKernel Information: \t\e[0m${red}" "Linux 5.10.0-BSA_OS-amd64 x86_64"
echo -e 'untuk mengecek logs: \e[1m\e[32msudo journalctl -u seid.service -f -o cat\e[0m'
echo -e "untuk mengecek status sync: \e[1m\e[32mseid status 2>&1 | jq .SyncInfo\e[0m"
echo
export PS1="\[\033[1;33m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;31m\]\w \[\033[1;36m\]\\$ \[\033[0m\]";




