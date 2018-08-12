# NadekoBot + Docker = Nadecker!
Containerized Kwoth's [NadekoBot](http://github.com/Kwoth/NadekoBot) for [Discord](https://discordapp.com) for easy deployment. Forked from [willysunny's](https://github.com/willysunny/Nadecker) Dockerfile.

## Tags

### latest
Corresponds to the [latest release](https://github.com/Kwoth/NadekoBot/releases/latest) of NadekoBot.

### latest-pre
Corresponds to the [latest pre-release](https://github.com/Kwoth/NadekoBot/releases) of NadekoBot.

### [numbered version]
Corresponds to a particular tag from NadekoBot's [tags list](https://github.com/Kwoth/NadekoBot/tags). Available tags are 2.16.7 and upwards.

## Usage

Example `docker run` command:
```
docker run \
  --name=nadekobot \
  -v nadekobot-conf:/root/nadeko \
  -v nadekobot-data:/opt/NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.0/data \
  -v nadekobot-data:/opt/NadekoBot/src/NadekoBot/data \
  1mmortal/nadecker:latest-pre
```
---
Example contents of a `docker-stack.yml` file for use with Docker Swarm Stack:
```
version: '3.7'

services:
  nadekobot:
    image: 1mmortal/nadecker:latest-pre
    deploy:
      restart_policy:
        condition: on-failure
        delay: 20s
        max_attempts: 3
        window: 60s
      placement:
        constraints: [node.role == worker]
    volumes:
      - nadekobot-conf:/root/nadeko
      - nadekobot-data:/opt/NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.0/data
      - nadekobot-data:/opt/NadekoBot/src/NadekoBot/data

volumes:
  nadekobot-data:
  nadekobot-conf:
```

Then deploy the stack by running `docker stack deploy -c docker-stack.yml nadekobot`
