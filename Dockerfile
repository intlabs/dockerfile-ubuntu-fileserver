#
# Ubuntu Desktop (Gnome) Dockerfile
#
# https://github.com/intlabs/dockerfile-ubuntu-fileserver
#

# Install GNOME3 and VNC server.
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

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
#CMD bash -C '/usr/local/etc/spawn-desktop.sh';'bash'
CMD "bash"
#CMD    /usr/sbin/sshd -D

# Expose ports.
EXPOSE 22