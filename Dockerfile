#
# Ubuntu Fileserver for CannyOS Dockerfile
#
# https://github.com/intlabs/dockerfile-ubuntu-fileserver
#

# (c) Pete Birley

# Pull base image.
FROM ubuntu:14.04

# Setup enviroment variables
ENV DEBIAN_FRONTEND noninteractive

#Update the package manager and upgrade the system
RUN apt-get update && \
apt-get upgrade -y && \
apt-get update

# Upstart and DBus have issues inside docker.
RUN dpkg-divert --local --rename --add /sbin/initctl && \
ln -sf /bin/true /sbin/initctl

#Install ssh server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd 

#Create user
RUN adduser --disabled-password --gecos "" user
RUN echo 'user:acoman' |chpasswd

#Set root password
RUN echo 'root:acoman' |chpasswd

#you can ssh into this container ssh user@<host> -p <whatever 22 has been mapped to>

#Install official dropbox sync utility
RUN cd / && \
wget -O dropbox.tar.gz "http://www.dropbox.com/download/?plat=lnx.x86_64" && \
tar -xvzf dropbox.tar.gz && \
mv .dropbox-dist dropbox-dist

# install official dropbox comand line utilities
ADD http://www.dropbox.com/download?dl=packages/dropbox.py /bin/dropbox.py

RUN apt-get install -y git

#Install fuse dropbox utility: https://github.com/intlabs/ff4d
RUN apt-get install -y libfuse2 python-pkg-resources python-pip
RUN cd / && git clone https://github.com/intlabs/ff4d.git
RUN pip install dropbox

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define entrypoint
ENTRYPOINT ["/usr/local/etc/startup.sh"]

# Expose ports.
#SSH
EXPOSE 22/tcp

# Copy in startup script.
ADD startup.sh /usr/local/etc/startup.sh
RUN chmod +x /usr/local/etc/startup.sh