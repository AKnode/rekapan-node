## NODE NODE AN : `node`
- Discord link is [here](https://discord.gg/mSecguCyht)
- Twitter [here](https://twitter.com/rehan_ssf)
- Telegram @paperhang
- 
# Instructions

# stride auto installation
```
wget -q -O stride.sh https://raw.githubusercontent.com/AKnode/rekapan-node/main/stride/stride.sh && chmod +x stride.sh && sudo /bin/bash stride.sh
```
after installation
```
source $HOME/.bash_profile
```
validator info
```
strided status 2>&1 | jq .ValidatorInfo

strided status 2>&1 | jq .SyncInfo

strided status 2>&1 | jq .NodeInfo
```



### create your wallet
Add New Wallet
```
strided keys add $WALLET
```
Recover Existing Wallet
```
strided keys add $WALLET --recover
```
save info Wallets
```
STRIDE_WALLET_ADDRESS=$(strided keys show $WALLET -a)

STRIDE_VALOPER_ADDRESS=$(strided keys show $WALLET --bech val -a)

echo 'export STRIDE_WALLET_ADDRESS='${STRIDE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export STRIDE_VALOPER_ADDRESS='${STRIDE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
cek wallet balance
```
strided query bank balances $STRIDE_WALLET_ADDRESS
```

# Validator
Create New Validator
```
strided tx staking create-validator \
  --amount 10000000ustrd \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $STRIDE_CHAIN_ID
```

# Operations with liquid stake
Add liquid stake
```
strided tx stakeibc liquid-stake 1000 uatom --from $WALLET --chain-id $STRIDE_CHAIN_ID
```
Redeem stake
```
strided tx stakeibc redeem-stake 999 GAIA <cosmos_address_you_want_to_redeem_to> --chain-id $STRIDE_CHAIN_ID --from $WALLET
```

# Check if tokens are claimable
If you'd like to see whether your tokens are ready to be claimed, look for your UserRedemptionRecord keyed by <your_stride_account>.
```
strided q records list-user-redemption-record --output json | jq --arg WALLET_ADDRESS "$STRIDE_WALLET_ADDRESS" '.UserRedemptionRecord | map(select(.sender == $WALLET_ADDRESS))'
```
# Claim tokens
```
strided tx stakeibc claim-undelegated-tokens GAIA 5 --chain-id $STRIDE_CHAIN_ID --from $WALLET
```


# Edit Existing Validator
```
strided tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$STRIDE_CHAIN_ID \
  --from=$WALLET
```
unjail
```
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$STRIDE_CHAIN_ID \
  --gas=auto
```
# Staking, Delegation and Rewards
```
# Delegate stake

strided tx staking delegate $STRIDE_VALOPER_ADDRESS 10000000ustrd --from=$WALLET --chain-id=$STRIDE_CHAIN_ID --gas=auto

# Redelegate stake from validator to another validator

strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=$WALLET --chain-id=$STRIDE_CHAIN_ID --gas=auto

# Withdraw all rewards

strided tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$STRIDE_CHAIN_ID --gas=auto

# Withdraw rewards with commision

strided tx distribution withdraw-rewards $STRIDE_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$STRIDE_CHAIN_ID
```
# Node info
```
strided status 2>&1 | jq .SyncInfo

strided status 2>&1 | jq .ValidatorInfo

strided status 2>&1 | jq .NodeInfo

strided tendermint show-node-id
```