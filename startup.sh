#!/bin/sh
# (c) Pete Birley

#Startup ssh
/usr/sbin/sshd -D &

set -e

# Define exports
echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

#Startup NFS server
runsvdir /etc/sv &

echo "to run the official dropbox util and mount the sync to ~/Dropbox:"
echo "/dropbox-dist/dropboxd"
echo " "
echo "to run the fuse dropbox filespace util and mount the sync to ~/Dropbox:"
echo "ff4d/getDropboxAccessToken.py"
echo "goto https://www.dropbox.com/developers/apps"
echo "create a new dropbox api app and use its generated output, go to the url specified"
echo "enter the responce and record the access token"
echo "run the follwing command to then mount your dropbox account:"
echo "ff4d/ff4d.py"