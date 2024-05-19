#! /bin/bash

# SYSTEM UPDATE ##################################################################################
sudo apt update && sudo apt -y upgrade

# GLOBAL SETTINGS ################################################################################

current_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo "actual directory: $current_dir"

data_file=$current_dir/data.json

echo "config_file: $data_file"

persistence_dir="/usr/persistence"

echo "containers persistent directory: $persistence_dir"

# JQ INSTALLATION #################################################################################

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

# DOCKER INSTALLATION #############################################################################

if ! docker -v &> /dev/null
then
	echo "Install Docker\n\n"
	curl -sSL https://get.docker.com | sh

	# check docker
	sudo docker run hello-world
fi

# PORTAINER INSTALLATION/RE-INSTALLATION

if [ $( docker ps -a | grep portainer | wc -l ) -gt 0 ]; 
then
sudo docker stop portainer
sudo docker rm portainer
fi
sudo mkdir -p "$persistence_dir/portainer_data"
sudo chown -R 9000:9000 "$persistence_dir/portainer_data"


 sudo docker create -it -p 9000:$(jq '.portainer.port' $data_file) \
 -p 9443:$(jq -r '.portainer.ssh_port' $data_file) \
 --name $(jq -r '.portainer.container_name' $data_file) \
 --restart=always -v /var/run/docker.sock:/var/run/docker.sock\
 -v $persistence_dir/portainer_data:/data\
  portainer/portainer-ce:latest

sudo docker start portainer

# MOSQUITTO INSTALLATION/RE-INSTALLATION
if [ $( docker ps -a | grep mqtt-broker | wc -l ) -gt 0 ]; 
then
sudo docker stop mqtt-broker
sudo docker rm mqtt-broker
fi


sudo mkdir -p "$persistence_dir/mosquitto/log"
sudo mkdir -p "$persistence_dir/mosquitto/data"
sudo mkdir -p "$persistence_dir/mosquitto/config"
sudo touch "$persistence_dir/mosquitto/config/mosquitto.passwd"
sudo touch "$persistence_dir/mosquitto/config/mosquitto.conf"

sudo echo "listener 1883 0.0.0.0" > "$persistence_dir/mosquitto/config/mosquitto.conf"
sudo echo "allow_anonymous false" >> "$persistence_dir/mosquitto/config/mosquitto.conf"
sudo echo "persistence_location /mosquitto/data/" >> "$persistence_dir/mosquitto/config/mosquitto.conf"
sudo echo "log_dest file /mosquitto/log/mosquitto.log" >> "$persistence_dir/mosquitto/config/mosquitto.conf"
sudo echo "password_file /mosquitto/config/mosquitto.passwd" >> "$persistence_dir/mosquitto/config/mosquitto.conf"

sudo chown -R 1883:1883 "$persistence_dir/mosquitto/"

sudo docker run --rm -d -p 1883:1883 -p 9001:9001 \
 --name mqtt-broker \
 eclipse-mosquitto:latest \

sudo docker exec -it mqtt-broker mosquitto_passwd -c -b /mosquitto/config/mosquitto.passwd $(jq -r '.mosquitto.user' $data_file) $(jq -r '.mosquitto.passwd' $data_file)
sudo docker cp mqtt-broker:/mosquitto/config/mosquitto.passwd "$persistence_dir/mosquitto/config/mosquitto.passwd"

sudo docker stop mqtt-broker

sudo docker create -it -p 1883:1883 -p 9001:9001 --name mqtt-broker --restart=always \
 -v "$persistence_dir/mosquitto/config/mosquitto.passwd":/mosquitto/config/mosquitto.passwd \
 -v "$persistence_dir/mosquitto/config/mosquitto.conf":/mosquitto/config/mosquitto.conf \
 -v "$persistence_dir/mosquitto/data/":/mosquitto/data \
 -v "$persistence_dir/mosquitto/log":/mosquitto/log \
 eclipse-mosquitto:latest


# NODE RED INSTALLATION/RE-INSTALLATION

if [ $( docker ps -a | grep nodered | wc -l ) -gt 0 ]; 
then
sudo docker stop nodered
sudo docker rm nodered
fi

sudo mkdir -p "$persistence_dir/node_red_data"
sudo chown -R 1000:1000 "$persistence_dir/node_red_data"
sudo docker create -it -p 1880:1880 --restart=always -v "$persistence_dir/node_red_data":/data --name nodered nodered/node-red:latest
 
sudo docker start mqtt-broker
sudo docker start nodered
sudo docker exec -it nodered npx node-red admin hash-pw sh



echo "end"

read -p "Press enter to exit"
