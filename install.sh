#! /bin/bash


# SYSTEM UPDATE ##################################################################################
# sudo apt update && sudo apt -y upgrade

# GLOBAL SETTINGS ################################################################################

current_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo "actual directory: $current_dir"

data_file=$current_dir/data.json

echo "config_file: $data_file"

persistence_dir="/usr/persistence"

echo "containers persistent directory: $persistence_dir"

# MOSQUITTO INSTALLATION

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
 --name $(jq -r '.mosquitto.container_name' $data_file) \
 eclipse-mosquitto:latest \

sudo docker exec -it $(jq -r '.mosquitto.container_name' $data_file) mosquitto_passwd -c -b /mosquitto/config/mosquitto.passwd $(jq -r '.mosquitto.user' $data_file) $(jq -r '.mosquitto.passwd' $data_file)
sudo docker cp $(jq -r '.mosquitto.container_name' $data_file):/mosquitto/config/mosquitto.passwd "$persistence_dir/mosquitto/config/mosquitto.passwd"

sudo docker stop $(jq -r '.mosquitto.container_name' $data_file)

sudo docker create -it -p 1883:1883 -p 9001:9001 --name $(jq -r '.mosquitto.container_name' $data_file) --restart=always \
 -v "$persistence_dir/mosquitto/config/mosquitto.passwd":/mosquitto/config/mosquitto.passwd \
 -v "$persistence_dir/mosquitto/config/mosquitto.conf":/mosquitto/config/mosquitto.conf \
 -v "$persistence_dir/mosquitto/data/":/mosquitto/data \
 -v "$persistence_dir/mosquitto/log":/mosquitto/log \
 eclipse-mosquitto:latest
fi

# NODE RED INSTALLATION

echo "installing node-red................................................"

sudo mkdir -p "$persistence_dir/node_red_data"
sudo chown -R 1000:1000 "$persistence_dir/node_red_data"
sudo docker create -it -p 1880:1880 --restart=always -v "$persistence_dir/node_red_data":/data --name $(jq -r '.nodered.container_name' $data_file) nodered/node-red:latest
 
sudo docker start $(jq -r '.mosquitto.container_name' $data_file)
sudo docker start $(jq -r '.nodered.container_name' $data_file)
#sudo docker exec -it $(jq -r '.nodered.container_name' $data_file) npx $(jq -r '.nodered.container_name' $data_file) admin hash-pw sh




#sudo mkdir -p "$persistence_dir/home-assistant"
#sudo chown -R 8123:8123 "$persistence_dir/home-assistant"
#docker run -d --name="home-assistant" -p 8123:8123 -v "$persistence_dir/home-assistant":/config -v "$persistence_dir/home-assistant":/etc/localtime:ro --net=host homeassistant/home-assistant

echo "end"

read -p "Press enter to exit"






echo "end"

read -p "Press enter to exit"
