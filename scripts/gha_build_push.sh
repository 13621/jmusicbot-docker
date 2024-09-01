#! /usr/bin/env nix-shell
#! nix-shell -p skopeo -i bash

set -e

OCI_ARCHIVE=$(nix build --print-out-paths)

skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://ghcr.io/${repo}"
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://ghcr.io/${repo}:latest"
