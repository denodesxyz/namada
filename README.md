# Guide to Setting Up a Namada Node

## Overview

[Namada](https://namada.net/) is a Proof-of-Stake L1 for interchain asset-agnostic privacy. Namada uses CometBFT consensus and enables multi-asset shielded transfers for any native or non-native asset. Namada features full IBC protocol support, a natively integrated Ethereum bridge, a modern proof-of-stake system with automatic reward compounding and cubic slashing, and a stake-weighted governance signalling mechanism. Users of shielded transfers are rewarded for their contributions to the privacy set in the form of native protocol tokens. A multi-asset shielded transfer wallet is provided in order to facilitate safe and private user interaction with the protocol.

- Blogpost: [Introducing Namada: Interchain Asset-agnostic Privacy](https://namada.net/blog/introducing-namada-interchain-asset-agnostic-privacy)
- Resources: [Website](https://namada.net/) // [Twitter](https://x.com/namada) // [Discord](https://discord.com/invite/namada) // [GitHub](https://github.com/anoma/namada) // [Docs](https://docs.namada.net/)

## Installing

### script execution

Use this script to install node:
```
wget -O namada.sh https://api.denodes.xyz/namada.sh && bash namada.sh
```

After installation, you need to wait for full synchronization. The following command should return "false":
```
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```
### wallet & faucet

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

### validator initialization

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

## Useful Commands

Here are some handy commands:

- Check logs: `sudo journalctl -u namadad -f`
- Restart your node: `sudo systemctl restart namadad`
- Check a wallet balance: `namada client balance --token NAM --owner $NAMADA_WALLET/`
- Check sync status: `curl -s localhost:26657/status | jq .result.sync_info.catching_up`

---
_Powered by [deNodes](https://twitter.com/_denodes)_
