#!/bin/bash

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || -z "$name" || "$ip" =~ ^# ]]; then
        continue
    fi

    nslookup_ip=$(nslookup "$name" 2>/dev/null | awk '/^Address: / { print $2; exit }')

    if [[ "$nslookup_ip" != "$ip" && -n "$nslookup_ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
