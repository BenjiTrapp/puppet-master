FROM kalilinux/kali-rolling

RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list  \
    && echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list \
    && sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends software-properties-common curl

RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
        openssh-server pwgen sudo vim-tiny \
	    supervisor \
        net-tools \
        lxde x11vnc xvfb autocutsel \
	    xfonts-base lwm xterm \
        nginx \
        python3-pip python3-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        dbus-x11 x11-utils \
        git \
        cewl \
        crunch \ 
        hydra \
        ncrack \
        gobuster \
        dirb \
        medusa \
        hashcat \
        cherrytree \
        golang \
        postgresql \
        sqlite3 \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U pip

# For installing other Kali metapackages check https://tools.kali.org/kali-metapackages
RUN apt-get update && apt-cache search kali-linux && apt-get install -y  \
        kali-tools-top10 \
        kali-tools-passwords \
        kali-tools-post-exploitation

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini


ADD containerfiles /
RUN pip3 install -r /usr/lib/web/requirements.txt

RUN chmod +x /bin/tini && \
    chmod +x /startup.sh && \
    chmod +x /opt/install-c2-server.sh && \
    bash /opt/install-c2-server.sh

RUN chmod -R u=rwx,go=rx /usr/lib/noVNC && \
    chmod -R u=rwx,go=rx /usr/lib/web && \
    chmod -R u=rwx,go=rx /usr/share/doro-lxde-wallpapers

EXPOSE 80
WORKDIR /root
ENV HOME=/root \
    SHELL=/bin/bash

ENTRYPOINT ["/startup.sh"]
CMD ["/bin/bash"]
