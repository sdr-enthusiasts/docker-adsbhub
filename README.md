# sdr-enthusiasts/docker-adsbhub

[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mikenye/adsbhub/latest)](https://hub.docker.com/r/mikenye/adsbhub)
[![Discord](https://img.shields.io/discord/734090820684349521)](https://discord.gg/sTf9uYF)

Docker container to send ADS-B data to [ADSBHub](https://www.adsbhub.org). Designed to work in tandem with [sdr-enthusiasts/docker-readsb-protobuf](https://github.com/sdr-enthusiasts/docker-readsb-protobuf). Builds and runs on `x86`, `x86_64`, `arm64`, `arm32v7` annd `arm32v6`.

This container pulls SBS/Basestation protocol data from a host or container, and sends the data to ADSBHub.

## Supported tags and respective Dockerfiles

* `latest` (`main` branch, `Dockerfile`)
* Version and architecture specific tags available

## First-time users

### Obtaining ADSBHub Station Key

First-time users should obtain a ADSBHub Station dynamic IP key. Follow the directions for steps 1 and 2 at [ADSBHub how to feed](https://www.adsbhub.org/howtofeed.php), ensuring your station is set up as a client and the data protocol set as "SBS".

### Setting up your station

In your station preferences, you should set the following:

* Feeder type: `Linux`
* Data Protocol: `SBS`
* Station mode: `Client`

## Up-and-Running with `docker run`

```shell
docker run \
 -d \
 --rm \
 --name adsbhub \
 -e TZ="YOURTIMEZONE" \
 -e SBSHOST=YOURSBSHOST \
 -e CLIENTKEY=YOURCLIENTKEY \
ghcr.io/sdr-enthusiasts/docker-adsbhub:latest
```

You should obviously replace `YOURSBSHOST`, and `YOURCLIENTKEY` with appropriate values.

For example:

```shell
docker run \
 -d \
 --rm \
 --name adsbhub \
 -e TZ="Australia/Perth" \
 -e SBSHOST=readsb \
 -e LAT=-33.33333 \
 -e LONG=111.11111 \
 -e CLIENTKEY=zg84632abhf231 \
ghcr.io/sdr-enthusiasts/docker-adsbhub:latest
```

## Up-and-Running with Docker Compose

```yaml
version: '2.0'

services:
  adsbhub:
    image: ghcr.io/sdr-enthusiasts/docker-adsbhub:latest
    tty: true
    container_name: adsbhub
    restart: always
    environment:
      - TZ=Australia/Perth
      - SBSHOST=readsb
      - CLIENTKEY=zg84632abhf231
```

### Escaping special characters

The ADSBHub client key is full of special characters, that can be misinterpreted on multiple levels. To avoid that:

* Wrap the environment variable assignment (the whole assignment, not just the key) in single quotation marks so that YAML parses it correctly.
* Duplicate every `$` character. The single `$` sign is the start of a [variable substitution](https://docs.docker.com/compose/compose-file/#variable-substitution) in docker-compose. Use `$$` instead.

If your client key was `abc$123$$$ABC`, your `docker-compose.yml` should look like this:

```yaml
environment:
  - 'CLIENTKEY=abc$$123$$$$$$ABC'
```

## Ports

No ports are exposed in this container

## Environment variables

| Variable | Description | Required | Default |
|----------|-------------|---------|--------|
| `TZ` | Timezone for the container. | Optional | `UTC` |
| `SBSHOST` | Host for RAW ADSB packets.| Required | Unset |
| `SBSPORT` | Port on SBSHOST that provides beast formatted ADSB packets | Optional | `30003` |
| `CLIENTKEY` | ADSBHub Station Dynamic IP key. | Required | Unset |

## Logging

* All processes are logged to the container's stdout, and can be viewed with `docker logs [-f] container`.

## Getting Help

You can [log an issue](https://github.com/sdr-enthusiasts/docker-adsbhub/issues) on the project's GitHub.

I also have a [Discord channel](https://discord.gg/sTf9uYF), feel free to [join](https://discord.gg/sTf9uYF) and converse.
