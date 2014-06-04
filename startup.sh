#!/bin/sh
# (c) Pete Birley

#Startup ssh
/usr/sbin/sshd -D &

set -e

app_key="${1}"
app_secret="${2}"
authorization_code="${3}"

echo "********************************************************************************"
echo "*                                                                              *"
echo "*    create a new dropbox api app and use its generated output                 *"
echo "*    go to the url specified bellow  (eaxple for cannyos testing)              *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""
echo "https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=$app_key"
echo ""
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
echo "*    Your dropbox drive will be mounted at ~/dropbox by default                *"
echo "*                                                                              *"
echo "*                                                                              *"
echo "*               (c) Pete Birley 2014 - petebirley@gmail.com                    *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""


#Install fuse - this is a really ugly hack to deal with fuse in dropbox during development
apt-get install -y fuse

#Get access token
/ff4d/getDropboxAccessToken.py -ak $app_key -as $app_secret -c $authorization_code &

#Make mountpoint
mkdir -p ~/dropbox

#Launch Dropbox FUSE
/ff4d/ff4d.py -ar -bg ~/dropbox 

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

