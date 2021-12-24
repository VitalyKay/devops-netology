#!/usr/bin/env bash
curl \
    --header "X-Vault-Token: root" \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/pki_int/issue/mycompany-dot-xyz > mycompany.xyz.keys.json


#vault write -format=json pki_int/issue/mycompany-dot-xyz common_name="mycompany.xyz" ttl="720h" > mycompany.xyz.keys.json
cat mycompany.xyz.keys.json | jq -r '.data.certificate' > mycompany.xyz.crt
cat mycompany.xyz.keys.json | jq -r '.data.private_key' > mycompany.xyz.key
cat mycompany.xyz.keys.json | jq -r '.data.ca_chain[0]' > mycompany.xyz.chain
cat mycompany.xyz.crt mycompany.xyz.chain > mycompany.xyz.chain.crt
/usr/sbin/nginx -s reload

