#!/bin/sh
echo ${ANYCONNECT_PASSWORD} |openconnect ${ANYCONNECT_SERVER} --user=${ANYCONNECT_USER}  -i tun127 -b
sleep 5
iptables -t nat -A POSTROUTING -o tun127 -j MASQUERADE
