#!/bin/bash

if [[ "$#" -ne "2" ]]; then
	echo "Use: $0 <user> <ssh-server>" >&2
	exit 1
fi

#server_side_mosh=/tmp/mosh-server
vars=$(ssh "${1}@${2}" "${MOSH_SERVER:-mosh-server}" | sed -n '/MOSH CONNECT/ p')
port=$(echo "${vars}"  | awk '{ print $3; }')
key=$(echo "${vars}"  | awk '{ print $4; }')

ip=$(dig +short "$2")

if [[ -n "${key}" && -n "${port}" && -n "$ip" ]]; then
	echo "MOSH_KEY=${key} mosh-client ${ip} ${port}"
	MOSH_KEY="${key}" mosh-client "${ip}" "${port}"
else
	echo "Something went wrong getting key / port / ip:"
	echo "${key} / ${port} / ${ip}"
fi
