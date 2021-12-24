# Barotrauma Dedicated Server

**[READ THE FULL DOCUMENT ON GITHUB](https://github.com/YanWenKun/barotrauma-server-docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/barotrauma-server-docker)**

- [`slim`](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/Dockerfile)
flavor will download & install the game server on first run. Will try update on following starts.
- [`preload`](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/Dockerfile.preload)
flavor already installed the game server. Will try update on every start.

## Quick hands-on

Slim image (recommended):

```
docker run \
  --name barotrauma-server-slim \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-gamedir:/home/runner/Steam/steamapps/common/Barotrauma Dedicated Server" \
  yanwk/barotrauma-server:slim
```

Pre-loaded image:

```
docker run \
  --name barotrauma-server-preloaded \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-gamedir:/home/runner/Steam/steamapps/common/Barotrauma Dedicated Server" \
  yanwk/barotrauma-server:preload
```

## Change your server settings

The whole `Barotrauma Dedicated Server` directory is mounted as a volume. You can tweak it like your local game. The dedicated server is basically a core version of the game.

After first start you need to modify (or copy from your local game folder, if you once started a non-dedicated server):

- `Data/clientpermissions.xml`
- `serversettings.xml`

Then restart the container for changes to take effect.

## How to use mods & Build your own & Advanced usage

Please follow [README on GitHub repo](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/README.adoc).

## Special Thanks

This repo is inspired by [cm2network/steamcmd](https://hub.docker.com/r/cm2network/steamcmd) 
and [goldfish92/barotrauma-dedicated-server](https://hub.docker.com/r/goldfish92/barotrauma-dedicated-server).
