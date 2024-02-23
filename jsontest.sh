#!/usr/bin/env bash

current_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

data_file=$current_dir/data.json

program="jq"
if [ "$(which $program)" == "" ]; 
then
    printf "$program is not installed. Do you wish to install it? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then 
        sudo apt install -y jq
    else
        exit 1
    fi
fi

echo $data_file

 user=$(jq '.mosquitto.user' $data_file)
# passw=$(jq '.mosquitto.passw' $data_file)
# port=$(jq '.mosquitto.port' $data_file)


echo $user






