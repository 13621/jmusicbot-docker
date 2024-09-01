#! /usr/bin/env -S nix shell . nixpkgs#bash --command bash

set -e

OCI_ARCHIVE=$(nix build --print-out-paths)
IMAGE="ghcr.io/${repo}"

echo "pushing image ${IMAGE}:${IMAGE_TAG}..."
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://${IMAGE}:${IMAGE_TAG}"

echo "pushing image ${IMAGE}:latest..."
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE}" "docker://${IMAGE}:latest"
