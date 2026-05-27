FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    masscan \
    tcpdump \
    hping3 \
    curl \
    wget \
    sqlmap \
    nikto \
    dirb \
    gobuster \
    hydra \
    medusa \
    python3 \
    net-tools \
    iputils-ping \
    dnsutils \
    jq \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /pentest
COPY scripts/ /pentest/scripts/
RUN chmod +x /pentest/scripts/*.sh 2>/dev/null || true
CMD ["tail", "-f", "/dev/null"]
