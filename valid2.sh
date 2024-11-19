#!/bin/bash

verify_ip() {
    local host_name=$1
    local ip_address=$2
    local dns_server=$3
    
    nslookup_ip=$(nslookup "$host_name" "$dns_server" 2>/dev/null | awk '/^Address: / { print $2; exit }')
    
    if [[ "$nslookup_ip" != "$ip_address" && -n "$nslookup_ip" ]]; then
        echo "Bogus IP for $host_name in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || -z "$name" || "$ip" =~ ^# ]]; then
        continue
    fi
    
    verify_ip "$name" "$ip" "8.8.8.8"
done