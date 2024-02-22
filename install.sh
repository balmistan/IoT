#! /bin/bash

sudo apt update && sudo apt -y upgrade

if ! docker -v &> /dev/null
then
	echo "Install Docker\n\n"
	curl -sSL https://get.docker.com | sh

	# check docker
	sudo docker run hello-world
fi


if ! [ $( docker ps -a | grep portainer | wc -l ) -gt 0 ]; 
then
	docker run -it -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

echo "end"