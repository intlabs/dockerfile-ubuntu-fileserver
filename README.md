## Ubuntu Desktop (GNOME) Dockerfile


This repository contains the *Dockerfile* and *associated files* for setting up a container with Ubuntu as an nfs server.

### Dependencies

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)
* the host must have the the nfs kernel server package installed (ubuntu 14.04)
	`sudo apt-get install -y nfs-kernel-server`


### Installation

1. Install [Docker](https://www.docker.io/).

	For an Ubuntu 14.04 host the following commands will get you up and running:

	`sudo apt-get -y update && \
	
	sudo apt-get -y install docker.io && \
	
	sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker && \
	
	sudo restart docker.io`


2. You can then pull the file:

	`sudo docker pull intlabs/dockerfile-ubuntu-fileserver`


	Or alternatively build an image from the Dockerfile:

	`sudo docker build -t="intlabs/dockerfile-ubuntu-fileserver" github.com/intlabs/dockerfile-ubuntu-fileserver`


### SuperQuick Install


	This will get you going superfast - one line! - from a fresh Ubuntu install (rememebr to update the /etc/hosts file to relect your hostname at 127.0.1.1)

	sudo apt-get -y update && \
	sudo apt-get -y install docker.io && \
	sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker && \
	sudo restart docker.io && \
	sudo docker pull intlabs/dockerfile-ubuntu-fileserver && \
	sudo docker run -it --rm -p 222:22 intlabs/dockerfile-ubuntu-fileserver


### Usage

#### Starting

* Change the port number to run multiple instances on the same host (remeber to open the ports for ingress)

* this will run and drop you into a session:

	`sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 --privileged=true intlabs/dockerfile-ubuntu-fileserver`

* or for silent running:

	`sudo docker run -it -d -p 222:22 -p 111:111 -p 2049:2049  --privileged=true intlabs/dockerfile-ubuntu-fileserver`


