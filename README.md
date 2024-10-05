# jmusicbot-docker

Docker container for [JMusicBot](https://github.com/jagrosh/MusicBot) based on its [Nixpkgs derivation](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/audio/jmusicbot/default.nix#L25) or built from source. The image is built using Nix's `buildLayeredImage` and uploaded to this repository's package registry.
The total image size (pulled) is 145 MB for all tags.

## How to use
1. Copy `docker-compose.example.yml` to an empty directory and rename it to `docker-compose.yml`
2. Create or copy your JMusicBot `config.txt` file (see [the official wiki](https://jmusicbot.com/setup/#3-configure-the-bot))
3. Edit the `volumes` part of your newly copied `docker-compose.yml` to match the path of your `config.txt` file (default path: `./config/config.txt`)
4. Start the container with docker compose

## Image tags
There are 4 image tags to choose from:

| Tag | JMusicBot version | JRE version |
| ----- | ------ | ----- |
| `master` | latest commit to [`master` branch](https://github.com/jagrosh/MusicBot/tree/master) (compiled from source) (does not work at the moment, use `master_fixed`) | based on `pkgs.jdk11_headless` |
| `master-fixed` | like `master`, but [with patches](https://github.com/13621/jmusicbot-docker/blob/main/e1afa185cc5d1ab84f815a4244257a3eea5e1fa2.patch) to fix compiling and 403 errors | based on `pkgs.jdk11_headless` |
| `latest` | latest JMusicBot release version | based on `pkgs.jdk11_headless` |
| release version, e.g. `0.4.3` | that specific JMusicBot release version | based on `pkgs.jdk11_headless` |

Using `latest` is recommended.
