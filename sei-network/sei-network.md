
sei-network testnet GUIDE
@paperhang

## sei-network testnet GUIDE: `sei-testnet-2`
- Official link link is [here](https://docs.seinetwork.io/nodes-and-validators/joining-testnets)
- Link explorer[Explorer](https://sei.explorers.guru/)
# Instructions
#### Manual Installation
```
sudo apt update
sudo apt install -y make gcc jq curl git
```

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER>
```

Save and import variables into system
```
SEI_PORT=12
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export SEI_CHAIN_ID=sei-testnet-2" >> $HOME/.bash_profile
echo "export SEI_PORT=${SEI_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


#### Install GO
```
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
sudo tar -xvf go1.18.1.linux-amd64.tar.gz
sudo mv go /usr/local
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
#### Install **interchain**
```
cd || return
rm -rf sei-chain
git clone https://github.com/sei-protocol/sei-chain.git
cd sei-chain || return
git checkout 1.0.5beta
make install
seid version
```
# replace aknode dengan moniker anda
```
seid init $NODENAME --chain-id sei-testnet-2 -o
```
```
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/genesis.json > ~/.sei/config/genesis.json
sha256sum $HOME/.sei/config/genesis.json
```
```
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-2/addrbook.json > ~/.sei/config/addrbook.json
sha256sum $HOME/.sei/config/addrbook.json
```
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001usei"|g' $HOME/.sei/config/app.toml
seeds=""
peers="f4b1aa3416073a4493de7889505fc19777326825@rpc1-testnet.nodejumper.io:28656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.sei/config/config.toml
```
```
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.sei/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.sei/config/app.toml
```
```
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
```
```
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book
```
```
SNAP_RPC="http://rpc1-testnet.nodejumper.io:28657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
```

```
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
```


```
sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sei/config/config.toml
```
## Start the service to synchronize from first block
```
sudo systemctl daemon-reload
sudo systemctl enable seid
sudo systemctl restart seid
```
### Logs and status
Logs
```
sudo journalctl -u seid -f --no-hostname -o cat
```


# Wallet

Add New Wallet
```
seid keys add wallet
```
Recover Existing Wallet
```
seid keys add wallet --recover
```
List All Wallets
```
seid keys list
```
Delete Wallet
```
seid keys delete wallet
```


# Validator Info
```
seid status 2>&1 | jq .ValidatorInfo
```
# Node info
```
seid status 2>&1 | jq .NodeInfo
```

