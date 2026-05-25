FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        suricata \
        libnetfilter-queue1 \
        iptables \
        tcpdump \
        net-tools \
        jq \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
