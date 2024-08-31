#! /bin/sh

set -e

OCI_ARCHIVE=$(nix build --print-out-paths)

nix run nixpkgs#skopeo -- --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://ghcr.io/${repo}"
nix run nixpkgs#skopeo -- --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://ghcr.io/${repo}:latest"