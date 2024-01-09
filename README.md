# namada

Use this script to install node:
```
wget -O namada.sh https://api.denodes.xyz/namada.sh && bash namada.sh
```

After installation, you need to wait for full synchronization. The following command should return "false":
```
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```

Next, generate a wallet and display it address:
```
source $HOME/.bash_profile
```
```
namada wallet address gen --alias $NAMADA_WALLET
```
```
namada wallet address find --alias my-account
```

Request tokens from the [faucet](https://faucet.heliax.click/) for this address.
Then check balance:
```
namada client balance --token NAM --owner $NAMADA_WALLET
```

Initialising a validator account:
```
namada client init-validator \
  --alias $NAMADA_ALIAS \
  --email $EMAIL \
  --account-keys $NAMADA_WALLET \
  --signing-keys $NAMADA_WALLET \
  --commission-rate 0.05 \
  --max-commission-rate-change 0.05
```

Bond token to your validator:
```
namada client bond \
  --validator $NAMADA_ALIAS \
  --amount 999 \
  --source $NAMADA_WALLET
```
