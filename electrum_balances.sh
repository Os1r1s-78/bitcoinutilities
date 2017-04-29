#! /bin/bash

totalchf=0
btcchf=$(curl -s https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=CHF | jq -r '.[0].price_chf')
echo $btcchf

printf "%25s\t%10s\t%8s\n" file BTC CHF

for f in ~/.electrum/wallets/*
do
    if [ -f "$f" ]
    then
        balance=$(electrum getbalance -w $f | jq -r '.confirmed')
        chf=$(echo "$balance $btcchf * p" | dc)
        printf "%25s\t%.8f\t%'.2f\n" $(basename $f) $balance $chf

        if [ "family_and_friends" != "$(basename $f)" ]
        then
            totalchf=$(echo "$totalchf $chf + p" | dc)
        fi
    fi
done

printf "total: %'.2f\n" $totalchf
