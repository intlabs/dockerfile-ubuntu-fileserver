## Ubuntu Desktop (GNOME) Dockerfile


This repository contains the *Dockerfile* and *associated files* for setting up a container with Ubuntu as a dropbox client

### Dependencies

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)
* the host must have the the nfs kernel server package installed (ubuntu 14.04)
	`sudo apt-get install -y nfs-kernel-server`
	`sudo service rpcbind stop`
	`sudo service nfs-kernel-server stop`


### Installation

1. Install [Docker](https://www.docker.io/).

	For an Ubuntu 14.04 host the following commands will get you up and running:

	`sudo apt-get -y update && \
	
	sudo apt-get -y install docker.io && \
	
	sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker && \
	
	sudo restart docker.io`


2. You can then build the file:

	`sudo docker build -t="intlabs/dockerfile-ubuntu-fileserver" github.com/intlabs/dockerfile-ubuntu-fileserver`

### Usage

#### Starting
* launch using: (for a new connection)

sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 \
--privileged=true --lxc-conf=\"native.cgroup.devices.allow = c 10:229 rwm\" \
--name test --hostname test \
-v /var/user-storage intlabs/dockerfile-ubuntu-fileserver \
new <app_key> <app_secret> <authorization_code>

* launch using: (for an existing connection)

sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 \
--privileged=true --lxc-conf=\"native.cgroup.devices.allow = c 10:229 rwm\" \
--name test --hostname test \
-v /var/user-storage intlabs/dockerfile-ubuntu-fileserver \
existing <access_token>

* Your dropbox drive will be mounted at /dropbox by default
* a symbolic link is made to /var/user-storage/dropbox