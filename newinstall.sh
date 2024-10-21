#! /bin/bash

# SYSTEM UPDATE ##################################################################################
#sudo apt update && sudo apt -y upgrade

# GLOBAL SETTINGS ################################################################################


config_file=$PWD/data.json

persistence_dir="$HOME/persistence"

sudo mkdir -p  "$persistence_dir";


echo "confif_file: "$config_file;
echo "persistens directory: "$persistence_dir;



# MOSQUITTO INSTALLATION

sudo mkdir -p "$persistence_dir/mosquitto/log"
sudo mkdir -p "$persistence_dir/mosquitto/data"
sudo mkdir -p "$persistence_dir/mosquitto/config"
sudo touch "$persistence_dir/mosquitto/config/mosquitto.passwd"
sudo touch "$persistence_dir/mosquitto/config/mosquitto.conf"


echo "listener 1883 0.0.0.0" | sudo tee "$persistence_dir/mosquitto/config/mosquitto.conf"
echo "allow_anonymous false" | sudo tee --append "$persistence_dir/mosquitto/config/mosquitto.conf"
echo "persistence_location /mosquitto/data/" | sudo tee --append "$persistence_dir/mosquitto/config/mosquitto.conf"
echo "log_dest file /mosquitto/log/mosquitto.log" | sudo tee --append "$persistence_dir/mosquitto/config/mosquitto.conf"
echo "password_file /mosquitto/config/mosquitto.passwd" | sudo tee --append "$persistence_dir/mosquitto/config/mosquitto.conf"



sudo chown -R 1883:1883 "$persistence_dir/mosquitto/"

echo "test........"

sudo docker run --rm -d -p 1883:1883 -p 9001:9001 \
 --name mqtt \
 eclipse-mosquitto:latest \

sudo docker exec -it mqtt mosquitto_passwd -c -b /mosquitto/config/mosquitto.passwd admin dalisan19780




sudo docker cp mqtt:/mosquitto/config/mosquitto.passwd "$persistence_dir/mosquitto/config/mosquitto.passwd"

sudo docker stop mqtt

sudo docker create -it -p 1883:1883 -p 9001:9001 --name mqtt --restart=always \
 -v "$persistence_dir/mosquitto/config/mosquitto.passwd":/mosquitto/config/mosquitto.passwd \
 -v "$persistence_dir/mosquitto/config/mosquitto.conf":/mosquitto/config/mosquitto.conf \
 -v "$persistence_dir/mosquitto/data/":/mosquitto/data \
 -v "$persistence_dir/mosquitto/log":/mosquitto/log \
 eclipse-mosquitto:latest


# NODE RED INSTALLATION

echo "installing node-red................................................"

sudo mkdir -p "$persistence_dir/node_red_data"
sudo chown -R 1000:1000 "$persistence_dir/node_red_data"
sudo docker create -it -p 1880:1880 --restart=always -v "$persistence_dir/node_red_data":/data --name node-red nodered/node-red:latest
 
sudo docker start node-red




read -p "Press enter to exit"
