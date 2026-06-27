FROM docker.io/tsl0922/ttyd:latest
LABEL maintainer="benjitrapp.github.io"

ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}
ENV GO111MODULE=on
ENV CGO_ENABLED=1
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/run

# System dependencies + Sliver cross-compilation requirements
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        curl \
        wget \
        git \
        make \
        zip \
        unzip \
        vim \
        python3 \
        python3-pip \
        iputils-ping \
        dnsutils \
        net-tools \
        gcc \
        libc6-dev \
        gcc-mingw-w64 \
        mingw-w64 \
        nmap \
        nasm \
        p7zip-full \
        jq \
        openssh-client \
        upx \
        sudo \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Install latest stable Go from upstream (apt version is too old for Sliver 1.21+ requirement)
RUN GOLATEST=$(curl -fsSL https://go.dev/VERSION?m=text | head -1) && \
    wget -q "https://dl.google.com/go/${GOLATEST}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf "${GOLATEST}.linux-amd64.tar.gz" && \
    rm "${GOLATEST}.linux-amd64.tar.gz" && \
    mkdir -p "${GOPATH}/bin"

EXPOSE 7681

COPY install.sh .
RUN chmod +x install.sh && ./install.sh && rm -f install.sh
