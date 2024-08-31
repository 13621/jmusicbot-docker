#! /bin/sh

set -e

OCI_ARCHIVE=$(nix build)

nix run nixpkgs#skopeo -- copy --additional-tag latest "docker-archive:${OCI_ARCHIVE}" "docker://ghcr.io/${repo}"
