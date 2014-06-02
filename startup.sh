#!/bin/sh
# (c) Pete Birley

#Startup ssh
/usr/sbin/sshd -D &

# Define exports
RUN echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

#Startup NFS server
runsvdir /etc/sv &

