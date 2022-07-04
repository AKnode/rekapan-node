## NODE NODE AN : `node`
- Discord link is [here](https://discord.gg/mSecguCyht)
- Twitter [here](https://twitter.com/rehan_ssf)
- Telegram @paperhang
- 
# Instructions

# Another auto installation
```
wget -q -O another-1.sh https://raw.githubusercontent.com/AKnode/rekapan-node/main/Another-1/another-1.sh && chmod +x another-1.sh && sudo /bin/bash another-1.sh
```
after installation
```
source $HOME/.bash_profile
```
validator info
```
anoned status 2>&1 | jq .ValidatorInfo

anoned status 2>&1 | jq .SyncInfo

anoned status 2>&1 | jq .NodeInfo
```



### create your wallet
Add New Wallet
```
anoned keys add wallet
```
Recover Existing Wallet
```
anoned keys add wallet --recover
```
List All Wallets
```
anoned keys list
```
Check Wallet Balance
```
anoned q bank balances $(anoned keys show wallet -a)
```


# Validator
Create New Validator
```
anoned tx staking create-validator \
--amount=1000000uan1 \
--pubkey=$(anoned tendermint show-validator) \
--moniker="<YOUR NODENAME>" \
--identity=<YOUR IDENTITY> \
--details="<YOUR DETAILS>" \
--chain-id=anone-testnet-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--fees=2000uan1 \
--gas=auto \
-y
```
Edit Existing Validator
```
anoned tx staking edit-validator \
--moniker="<YOUR NODENAME>" \
--identity="<YOUR IDENTITY>" \
--details="<YOUR DETAILS>" \
--chain-id=anone-testnet-1 \
--commission-rate=0.1 \
--from=wallet \
--fees=2000uan1 \
--gas=auto \
-y
```
Unjail Validator
```
anoned tx slashing unjail --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y
```
Jail Reason
```
anoned query slashing signing-info $(anoned tendermint show-validator)
```
Withdraw Commission And Rewards
```
anoned tx distribution withdraw-all-rewards --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```
Delegate
```
anoned tx staking delegate <YOUR_VALOPER_ADDRESS> 1000000uan1 --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```
Redelegate
```
anoned tx staking redelegate <YOUR_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 1000000uan1 --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```
Unbond
```
anoned tx staking unbond <YOUR_VALOPER_ADDRESS> 1000000uan1 --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```
Send
```
anoned tx bank send wallet <TO_WALLET_ADDRESS> 1000000uan1 --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```

# Governance
Vote proposal
```
anoned tx gov vote <proposal id> yes/no --from wallet --chain-id anone-testnet-1 --fees 2000uan1 --gas auto -y 
```