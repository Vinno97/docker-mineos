FROM node:carbon
MAINTAINER Vincent Brouwers
ENV MINEOS_VERSION 1.3.0

# Installing Dependencies
RUN apt-get update && \
    apt-get -y install git rdiff-backup screen openjdk-8-jre-headless uuid pwgen curl rsync && \
    apt -y autoremove && \
    apt-get clean

# Installing MineOS scripts
RUN mkdir -p /usr/games/minecraft /var/games/minecraft; \
    curl -L https://github.com/hexparrot/mineos-node/archive/${MINEOS_VERSION}.tar.gz | tar xz -C /usr/games/minecraft --strip=1 && \
    cd /usr/games/minecraft && \
    npm install && \
    chmod +x service.js mineos_console.js generate-sslcert.sh webui.js && \
    ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos

# Customize server settings
ADD mineos.conf /etc/mineos.conf

# Add start script
ADD start.sh /usr/games/minecraft/start.sh
RUN chmod +x /usr/games/minecraft/start.sh

# Add minecraft user and change owner files.
RUN useradd -M -s /bin/bash -d /usr/games/minecraft minecraft

# Cleaning

VOLUME /var/games/minecraft
WORKDIR /usr/games/minecraft
EXPOSE 8443 25565

CMD ["./start.sh"]
