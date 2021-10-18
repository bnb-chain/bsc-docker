#!/usr/bin/env python3

from web3 import Web3, HTTPProvider
import os

private_keys = './init-holders'
idx = 1
w3 = Web3(HTTPProvider('http://localhost:8545', request_kwargs={'timeout': 120}))
for keystore_file in os.listdir(private_keys):
    with open("%s/%s" % (private_keys, keystore_file)) as keyfile:
        encrypted_file = keyfile.read()
        private_key = w3.eth.account.decrypt(encrypted_file, '')
        acct = w3.eth.account.privateKeyToAccount(private_key)
        print('Account %s: %s, private key: %s' % (idx, Web3.toChecksumAddress(acct.address), private_key.hex()))
        idx = idx + 1
    