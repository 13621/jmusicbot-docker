# jmusicbot-docker

![downloads](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fipitio.github.io%2Fbackage%2F13621%2Fjmusicbot-docker%2Fjmusicbot-docker.xml&query=%2Fbkg%2Fsize&logo=github&label=size&link=https%3A%2F%2Fgithub.com%2F13621%2Fjmusicbot-docker)

Very small docker container for [JMusicBot](https://github.com/jagrosh/MusicBot) based on its [Nixpkgs derivation](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/audio/jmusicbot/default.nix#L25) or built from source. The image is built using Nix's `buildLayeredImage` and uploaded to this repository's package registry.
The total image size (uncompressed) is about 112 MB. This is achieved by using a custom-built JRE, which is built with musl and only using a minimal set of standard modules.

## How to use
1. Copy `docker-compose.example.yml` to an empty directory and rename it to `docker-compose.yml`
2. Create or copy your JMusicBot `config.txt` file (see [the official wiki](https://jmusicbot.com/setup/#3-configure-the-bot))
3. Edit the `volumes` part of your newly copied `docker-compose.yml` to match the path of your `config.txt` file (default path: `./config/config.txt`)
4. `docker compose up -d`

## Image tags
There are 4 image tags to choose from:

| Tag | JMusicBot version |
| ----- | ------ |
| `master` | latest commit to [`master` branch](https://github.com/jagrosh/MusicBot/tree/master) (compiled from source) (does not work at the moment, use `master_fixed`) |
| `master-fixed` | like `master`, but [with patches](https://github.com/13621/jmusicbot-docker/blob/main/e1afa185cc5d1ab84f815a4244257a3eea5e1fa2.patch) to fix compiling and 403 errors |
| `latest` | latest JMusicBot stable release |
| stable release, e.g. `0.4.3` | that specific JMusicBot release version |

Using `latest` is recommended, as it is the latest officially released version. `master` or `master-fixed` are updated each day to match the latest upstream commit, but may be less stable.
