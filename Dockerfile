FROM docker.io/tsl0922/ttyd:latest
LABEL maintainer="benjitrapp.github.io"


WORKDIR /var/run

RUN apt-get update && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        iputils-ping \
        vim \
        python3-pip \
        dnsutils \
        apt-file \
        glibc-source \
        golang \
        net-tools \
        gcc \
        libc6 \
        libc6-dev \
        gcc-mingw-w64 \
        nmap \
        nasm \
        stow \
        git-core \
        sudo \
        util-linux\
        p7zip-full \
        jq \
        ssh \
        python \
        python3 \
        upx \
        && rm -rf /var/lib/apt/lists/*

EXPOSE 7681
COPY install.sh .
RUN chmod +x install.sh && ./install.sh && rm -f install.sh