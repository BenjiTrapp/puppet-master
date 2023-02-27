FROM kalilinux/kali-rolling:latest

LABEL org.opencontainers.image.author="benjitrapp.github.io"

ARG KALI_METAPACKAGE=core
ARG KALI_DESKTOP=xfce

ENV VNCEXPOSE 1
ENV VNCPORT 5900
ENV VNCPWD password
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16
ENV USER root

ENV NOVNCPORT 8080
ENV DEBIAN_FRONTEND noninteractive

ENV GOROOT=/usr/lib/go
ENV GO111MODULE=on
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get clean \
    && apt-get install -y --no-install-recommends software-properties-common curl wget vim nano

RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
        openssh-server pwgen sudo vim-tiny \
	supervisor \
        net-tools \
        binutils \
	xfonts-base lwm xterm \
        nginx \
        python3-pip python3-full python3-dev build-essential \
        golang-go \
        git \
        jq \
        powershell \
        whois \
        proxychains4 \
        libproxychains4 \
        sslscan \
        traceroute \
        cewl \
        crunch \ 
        fail2ban \
        hydra \
        tor \
        ncrack \
        gobuster \
        dirb \
        kerberoast \
        bloodhound \
        medusa \
        hashcat \
        cherrytree \
        golang \
        postgresql \
        sqlite3 \
        tightvncserver \
        dbus \
        dbus-x11 \
        novnc \
        net-tools \
        xfonts-base \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# For installing other Kali metapackages check https://tools.kali.org/kali-metapackages
RUN apt-get update && apt-cache search kali-linux && apt-get install -y  \
        kali-linux-${KALI_METAPACKAGE} \
        kali-desktop-${KALI_DESKTOP} \
        kali-tools-web \
        kali-tools-windows-resources \
        kali-tools-top10 \
        kali-tools-passwords \
        kali-tools-post-exploitation

RUN pip3 install --break-system-package --no-cache-dir --upgrade pip  && \
    pip3 install --break-system-package --no-cache-dir awscli boto3 pacu trufflehog endgame notebook

ADD containerfiles /

# Install C2 Server next to the existing stuff
RUN chmod +x /opt/install-c2-server.sh && \
    chmod +x /opt/entrypoint.sh && \
    bash /opt/install-c2-server.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
