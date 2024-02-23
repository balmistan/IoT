#! /bin/bash

# SYSTEM UPDATE
# sudo apt update && sudo apt -y upgrade

# GLOBAL SETTINGS

current_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo "actual directory: $current_dir"

data_file=$current_dir/data.json

echo "config_file: $data_file"

persistence_dir="/usr/persistence/"

echo "containers persistent directory: $persistence_dir"

# DOCKER INSTALLATION 

if ! docker -v &> /dev/null
then
	echo "Install Docker\n\n"
	curl -sSL https://get.docker.com | sh

	# check docker
	sudo docker run hello-world
fi

# JQ INSTALLATION

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

# PORTAINER INSTALLATION

if ! [ $( docker ps -a | grep portainer | wc -l ) -gt 0 ]; 
then
sudo mkdir -p "$persistence_dir/portainer_data"
sudo chown -R 9000:9000 "$persistence_dir/portainer_data"


 sudo docker run -it -p 9000:$(jq '.portainer.port' $data_file) \
 -p 9443:$(jq -r '.portainer.ssh_port' $data_file) \
 --name $(jq -r '.portainer.container_name' $data_file) \
 --restart=always -v /var/run/docker.sock:/var/run/docker.sock\
 -v $persistence_dir/portainer_data:/data\
  portainer/portainer-ce:latest
fi



echo "end"
