#
# Ubuntu Fileserver for CannyOS Dockerfile
#
# https://github.com/intlabs/dockerfile-ubuntu-fileserver
#

# (c) Pete Birley

# Pull base image.
FROM dockerfile/ubuntu

# Setup enviroment variables
ENV DEBIAN_FRONTEND noninteractive

#Update the package manager and upgrade the system
RUN apt-get update && \
apt-get upgrade -y && \
apt-get update

# Upstart and DBus have issues inside docker.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

#Install ssh server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd 

#Create user
RUN adduser --disabled-password --gecos "" user
RUN echo 'user:acoman' |chpasswd

#you can ssh into this container ssh user@<host> -p <whatever 22 has been mapped to>

RUN apt-get update -qq && apt-get install -y nfs-kernel-server runit inotify-tools -qq
RUN mkdir -p /exports


RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
RUN chmod 755 /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish
RUN chmod 755 /etc/sv/nfs/finish


# Define exports
RUN echo '/home   *(rw,sync,fsid=0,no_subtree_check)' >> /etc/exports

ADD startup.sh /usr/local/etc/startup.sh
RUN chmod +x /usr/local/etc/startup.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD bash -C '/usr/local/etc/startup.sh';'bash'
#CMD "bash"

# Expose ports.

#SSH
EXPOSE 22/tcp

#NFS
EXPOSE 111/udp 2049/tcp