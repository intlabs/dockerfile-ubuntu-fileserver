#!/bin/sh
# (c) Pete Birley

apt-get install -y fuse

#Startup ssh
/usr/sbin/sshd -D &

set -e


app_key="${1}"
app_secret="${2}"
authorization_code="${3}"


# Define exports
echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

#Startup NFS server
runsvdir /etc/sv &

echo "to run the official dropbox util and mount the sync to ~/Dropbox:"
echo "/dropbox-dist/dropboxd"
echo " "
echo "to run the fuse dropbox filespace util and mount the sync to ~/Dropbox:"
echo "/ff4d/getDropboxAccessToken.py"
echo "goto https://www.dropbox.com/developers/apps"
echo "create a new dropbox api app and use its generated output, go to the url specified"
echo "enter the responce and record the access token"
echo "https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=axq0c8se5oo7ndh"
echo "run the follwing command to then mount your dropbox account:"
echo "mkdir -p ~/Dropbox && /ff4d/ff4d.py -at <YOURACCESSKEY> -ar ~/Dropbox &"

/ff4d/getDropboxAccessToken.py -ak $app_key -as $app_secret -c $authorization_code
mkdir -p ~/Dropbox
/ff4d/ff4d.py -ar -bg ~/Dropbox 
bash