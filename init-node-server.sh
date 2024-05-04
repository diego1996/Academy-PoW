#!/bin/bash

PASSWORD="Pl3n17uDN0d3"

academy-pow key insert --base-path /data/node01 --chain plenitudSpecRaw.json --scheme Ecdsa --suri "vacuum mandate digital voice play control another milk attitude install diary shield" --password $PASSWORD --key-type aura

academy-pow --base-path /data/node01 \
  --chain ./plenitudSpecRaw.json \
  --port 30333 \
  --rpc-port 9945 \
  --telemetry-url "wss://telemetry.polkadot.io/submit/ 0" \
  --validator \
  --rpc-methods Unsafe \
  --name splendor-node \
  --rpc-external --rpc-cors all \
  --ws-external --no-mdns \
  --node-key 2980169f85d6d5e7f82b62ff01ce679bfd3d8dedc0d244c556336da97f03fc8b \
  --pruning archive \
  --offchain-worker always \
  --password $PASSWORD
