# Barotrauma Dedicated Server

**[READ THE FULL DOCUMENT ON GITHUB](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/README.adoc)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/README.zh.adoc)**

## Choose Your Tag

- [`dockerful`](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/Dockerfile.dockerful)
: No SteamCMD. Fast startup. Update via docker image.
  - Runs server in a 'containerized' style.
  - Suits for any quick game.
- [`slim`](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/Dockerfile.slim)
: With SteamCMD. Install the server on first start. Update upon restart.
  - Recommended for long-running server.
  - Safer way for customization/mods.
- [`preload`](https://github.com/YanWenKun/barotrauma-server-docker/blob/main/Dockerfile.preload)
: `slim` with server installed.
  - Use it only when `slim` is not working.
  - If still not working, just use `dockerful`.

Note: SteamCMD is the CLI version of Steam client, used for downloading games/apps.

## Run `dockerful`


```
docker run \
  --name barotrauma-server-dockerful \
  --env DEFAULT_SERVERNAME=AABBCC \
  --env DEFAULT_PASSWORD=112233 \
  --env DEFAULT_PUBLICITY=true \
  --env DEFAULT_LANGUAGE="English" \
  --env DEFAULT_OWNER_STEAMNAME="S0m3_b0dy" \
  --env DEFAULT_OWNER_STEAMID=5566778899 \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-data:/persistence" \
  yanwk/barotrauma-server:dockerful
```

**Updating:**

```
docker rm --force barotrauma-server-dockerful

docker run \
  --name barotrauma-server-dockerful \
  --env FORCE_SERVERNAME=BBCCAA \
  --env FORCE_PASSWORD=223344 \
  --env FORCE_PUBLICITY=true \
  --env FORCE_LANGUAGE="English" \
  --env FORCE_OWNER_STEAMNAME="S0m3_b0dy" \
  --env FORCE_OWNER_STEAMID=5566778899 \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-data:/persistence" \
  yanwk/barotrauma-server:dockerful
```

## Run `slim` or `preload`

`slim`

```
docker run \
  --name barotrauma-server-slim \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-gamedir:/home/runner/Steam/steamapps/common/Barotrauma Dedicated Server" \
  yanwk/barotrauma-server:slim
```

`preload`

```
docker run \
  --name barotrauma-server-preloaded \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -v "baro-gamedir:/home/runner/Steam/steamapps/common/Barotrauma Dedicated Server" \
  yanwk/barotrauma-server:preload
```

**After first start you need to edit these files:**

- `Data/clientpermissions.xml`
- `serversettings.xml`

Tip: if you once started a server on your computer, just copy these files from it.

Note: The whole 'Barotrauma Dedicated Server' directory is mounted as a volume. You can edit it like your local game. The dedicated server is basically a core subset of the game.

**Then restart the container for changes to take effect:**

```
docker restart barotrauma-server-slim
```

```
docker restart barotrauma-server-preloaded
```

## How to enable Mods

Please follow [The Full README](https://github.com/YanWenKun/barotrauma-server-docker#prepare-your-files).


## Special Thanks

This repo is inspired by [cm2network/steamcmd](https://hub.docker.com/r/cm2network/steamcmd) 
and [goldfish92/barotrauma-dedicated-server](https://hub.docker.com/r/goldfish92/barotrauma-dedicated-server).
