FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    masscan \
    tcpdump \
    hping3 \
    curl \
    sqlmap \
    nikto \
    dirb \
    gobuster \
    hydra \
    python3 \
    net-tools \
    iputils-ping \
    dnsutils \
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /pentest
COPY scripts/ /pentest/scripts/
RUN chmod +x /pentest/scripts/*.sh 2>/dev/null || true
CMD ["bash"]
