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

#Install nfs kernel server
RUN apt-get install -y nfs-kernel-server

#Insatll runninit to provide runsvdir (http://manpages.ubuntu.com/manpages/trusty/man8/runsvdir.8.html)
RUN apt-get install -y runit inotify-tools

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
RUN chmod 755 /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish
RUN chmod 755 /etc/sv/nfs/finish

ADD startup.sh /usr/local/etc/startup.sh
RUN chmod +x /usr/local/etc/startup.sh


RUN cd / && wget -O dropbox.tar.gz "http://www.dropbox.com/download/?plat=lnx.x86_64" && tar -xvzf dropbox.tar.gz && mv .dropbox-dist dropbox-dist

ADD http://www.dropbox.com/download?dl=packages/dropbox.py /bin/dropbox.py

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