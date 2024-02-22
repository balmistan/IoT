#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

yml_path=$SCRIPTPATH/data.yml

user=$(yq '.mosquitto.user' $yml_path)
passw=$(yq '.mosquitto.passw' $yml_path)
port=$(yq '.mosquitto.port' $yml_path)

echo "Details are $user: $passw - port $port"