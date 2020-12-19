# mikenye/adsbhub

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/mikenye/docker-adsbhub/Deploy%20to%20Docker%20Hub)](https://github.com/mikenye/docker-adsbhub/actions?query=workflow%3A%22Deploy+to+Docker+Hub%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/mikenye/adsbhub.svg)](https://hub.docker.com/r/mikenye/adsbhub)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mikenye/adsbhub/latest)](https://hub.docker.com/r/mikenye/adsbhub)
[![Discord](https://img.shields.io/discord/734090820684349521)](https://discord.gg/sTf9uYF)

Docker container to send ADS-B data to [ADSBHub](https://www.adsbhub.org). Designed to work in tandem with [mikenye/readsb-protobuf](https://hub.docker.com/r/mikenye/readsb-protobuf). Builds and runs on `x86`, `x86_64`, `arm64`, `arm32v7` annd `arm32v6`.

This container pulls SBS/Basestation protocol data from a host or container, and sends the data to ADSBHub.

Thanks go to [fredclausen](https://github.com/fredclausen) for developing the original image.

## Documentation

Please [read this container's detailed and thorough documentation in the GitHub repository.](https://github.com/mikenye/docker-adsbhub/blob/master/README.md)