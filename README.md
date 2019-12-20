# grok_exporter

An up-to-date version of grok_exporter with journalctl for use with stdin.

Start with journalctl

```bash
docker run \
  -d \
  -v ./grok-exporter.yml:/grok/config.yml:ro \
  -v /var/log/journal:/var/log/journal:ro \
  -v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket \
  --health-cmd='wget --quiet --tries=1 --spider http://localhost:9144/ || exit 1' \
  --health-start-period=60s \
  --health-retries=3 \
  --health-timeout=5s \
  --health-interval=5s \
  --restart=unless-stopped \
  --log-driver=journald \
  premiereglobal/grok_exporter:latest
    bash -c 'journalctl -f -D /var/log/journal | ./grok_exporter -config /grok/config.yml'
```


Start with without journalctl

```bash
docker run \
  -d \
  -v ./grok-exporter.yml:/grok/config.yml:ro \
  --health-cmd='wget --quiet --tries=1 --spider http://localhost:9144/ || exit 1' \
  --health-start-period=60s \
  --health-retries=3 \
  --health-timeout=5s \
  --health-interval=5s \
  --restart=unless-stopped \
  --log-driver=journald \
  premiereglobal/grok_exporter:latest
    ./grok_exporter -config /grok/config.yml
```
