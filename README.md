# nut-cgi for docker

A lightweight web UI for monitoring UPS statistics would provide a user-friendly interface for viewing and analyzing the performance and status of Uninterruptible Power Supplies (UPS).

This docker file was built with
* nut-cgi
* lighttpd

## Example of docker-compose.yml

```yaml
version: '3'

services:

  webnut:
    build: ./
    container_name: webnut
    restart: always
    ports:
      - "8080:80"
    volumes:
      - ./hosts.conf:/etc/nut/hosts.conf:ro

```

## Links

* https://networkupstools.org/
