# jmusicbot-docker

Docker container for [JMusicBot](https://github.com/jagrosh/MusicBot) based on its [Nixpkgs derivation](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/audio/jmusicbot/default.nix#L25). The image is built using Nix's `buildLayeredImage` and uploaded to this repository's package registry.
The total image size is currently 145 MB.

## How to use
1. Copy `docker-compose.example.yml` to an empty directory and rename it to `docker-compose.yml`
2. Create or copy your JMusicBot `config.txt` file (see [the official wiki](https://jmusicbot.com/setup/#3-configure-the-bot))
3. Edit the `volumes` part of your newly copied `docker-compose.yml` to match the path of your `config.txt` file (default path: `./config/config.txt`)
4. Start the container with docker compose

