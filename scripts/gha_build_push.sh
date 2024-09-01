#! /usr/bin/env -S nix develop . --command bash

set -eu

OCI_ARCHIVE=$(nix build --print-out-paths)
IMAGE="ghcr.io/${repo}"

echo "nix store path: ${OCI_ARCHIVE}"

echo "pushing image ${IMAGE}:${IMAGE_TAG}"
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://${IMAGE}:${IMAGE_TAG}"

echo "pushing image ${IMAGE}:latest"
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://${IMAGE}:latest"
