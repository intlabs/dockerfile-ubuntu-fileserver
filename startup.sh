#!/bin/sh
# (c) Pete Birley

#Startup ssh
/usr/sbin/sshd -D &

set -e

#if set to new - it will expect the app_key, app_secret and authorisation code to be supplied
#if set to existing - it will expect the access_token to be supplied
mode="${1}"

if [ "$mode" = "new" ]; then
	app_key="${2}"
	app_secret="${3}"
	authorization_code="${4}"
	echo "********************************************************************************"
	echo "*                                                                              *"
	echo "*    this mode expects you to have done the following:                         *"
	echo "*    create a new dropbox api app and use its generated output                 *"
	echo "*    go to the url specified bellow  (exaple for cannyos testing)              *"
	echo "*                                                                              *"
	echo "********************************************************************************"
	echo ""
	echo "https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=$app_key"
	echo ""
fi

if [ "$mode" = "existing" ]; then
	access_token="${2}"
	echo "********************************************************************************"
	echo "*                                                                              *"
	echo "*    this mode expects you to have already got an access_token                 *"
	echo "*                                                                              *"
	echo "********************************************************************************"
	echo ""
fi

echo "********************************************************************************"
echo "*                                                                              *"
echo "*    this docker containter should then be launched using the command          *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""
echo "sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 --privileged=true --lxc-conf=\"native.cgroup.devices.allow = c 10:229 rwm\" intlabs/dockerfile-ubuntu-fileserver <app_key> <app_secret> <authorization_code>"
echo ""
echo "********************************************************************************"
echo "*                                                                              *"
echo "*    Your dropbox drive will be mounted at /dropbox by default                *"
echo "*                                                                              *"
echo "*                                                                              *"
echo "*               (c) Pete Birley 2014 - petebirley@gmail.com                    *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""


#Install fuse - this is a really ugly hack to deal with fuse in dropbox during development
apt-get install -y fuse


if [ "$mode" = "new" ]; then
	#Get a new access token
	/ff4d/getDropboxAccessToken.py -ak $app_key -as $app_secret -c $authorization_code 
fi

if [ "$mode" = "existing" ]; then
	#Store access token
	echo $access_token >> /ff4d/ff4d.config
fi

#Make mountpoint
mkdir -p ~/dropbox

#Launch Dropbox FUSE
/ff4d/ff4d.py -ar -bg ~/dropbox 

#Symlink dropbox fuse mountpoint to /var/user-storage
ln -s ~/dropbox /var/user-storage

# Define exports
echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

#Startup NFS server
runsvdir /etc/sv &


#Announce bonus package option - can be used to sync folders.
echo "BONUS!"
echo "to run the official dropbox util and mount & sync to ~/Dropbox:"
echo "/dropbox-dist/dropboxd"

# Drop into a command prompt
bash

