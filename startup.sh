#!/bin/sh
# (c) Pete Birley

#Startup ssh
/usr/sbin/sshd -D &

set -e

# Define exports
echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

#Startup NFS server
exec runsvdir /etc/sv &

