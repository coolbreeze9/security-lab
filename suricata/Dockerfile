FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        suricata \
        libnetfilter-queue1 \
        net-tools \
        jq \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
