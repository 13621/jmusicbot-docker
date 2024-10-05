#! /usr/bin/env -S nix develop --command bash

set -eu

OCI_ARCHIVE_NIXPKGS=$(nix build .#default --print-out-paths)
OCI_ARCHIVE_MASTER=$(nix build .#master --print-out-paths)
IMAGE="ghcr.io/${repo}"

echo "pushing image ${IMAGE}:${IMAGE_TAG_NIXPKGS}"
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE_NIXPKGS}" "docker://${IMAGE}:${IMAGE_TAG_NIXPKGS}"

echo "pushing image ${IMAGE}:latest"
skopeo --insecure-policy copy "docker://${IMAGE}:${IMAGE_TAG_NIXPKGS}" "docker://${IMAGE}:latest"

echo "pushing image ${IMAGE}:${IMAGE_TAG_MASTER}"
skopeo --insecure-policy copy "docker-archive:${OCI_ARCHIVE_MASTER}" "docker://${IMAGE}:${IMAGE_TAG_MASTER}"

