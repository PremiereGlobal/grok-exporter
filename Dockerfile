# must be >= the systemd version on the host
ENV SYSTEMD_VERSION=242
ENV GROK_EXPORTER_VERSION=0.2.8

FROM ubuntu:18.04 as builder

RUN apt update && \
    apt install -y wget unzip meson python3-pip m4 gperf libcap-dev pkg-config libmount-dev

RUN pip3 install meson

WORKDIR /tmp

RUN  wget -q https://github.com/systemd/systemd/archive/v${SYSTEMD_VERSION}.zip && \
     unzip -q v${SYSTEMD_VERSION}.zip && \
     cd systemd-${SYSTEMD_VERSION} && \
     ./configure && \
     make && \
     make install


FROM ubuntu:18.04

RUN apt update && \
    apt install -y wget unzip

RUN cd /tmp && \
    wget -q https://github.com/fstab/grok_exporter/releases/download/v${GROK_EXPORTER_VERSION}/grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64.zip && \
    unzip -q grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64.zip && \
    cp -r grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64 /grok && \
    rm -rf grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64*

COPY --from=builder /bin/journalctl /bin
COPY --from=builder /lib/systemd/libsystemd-* /lib/systemd/
COPY --from=builder /lib/x86_64-linux-gnu/libcap* /lib/x86_64-linux-gnu/

WORKDIR /grok

CMD journalctl -f -D /var/log/journal | ./grok_exporter -config /grok/config.yml