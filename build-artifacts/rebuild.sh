#!/bin/bash
set -euo pipefail

VERSION="${1:?Usage: $0 <libfranka-version> (e.g. 0.15.0, 0.17.0)}"
IMAGE="ghcr.io/droid-dataset/droid_nuc:fr3-${VERSION}"
CONTAINER="build_franka_${VERSION//\./_}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUT_DIR="${SCRIPT_DIR}/${VERSION}"

SRC_CPP="${REPO_DIR}/droid/fairo/polymetis/polymetis/src/clients/franka_panda_client/franka_panda_client.cpp"
SRC_HPP="${REPO_DIR}/droid/fairo/polymetis/polymetis/include/polymetis/clients/franka_panda_client.hpp"
DST_CPP="/app/droid/fairo/polymetis/polymetis/src/clients/franka_panda_client/franka_panda_client.cpp"
DST_HPP="/app/droid/fairo/polymetis/polymetis/include/polymetis/clients/franka_panda_client.hpp"
BUILD_DIR="/app/droid/fairo/polymetis/polymetis/build"
BIN="${BUILD_DIR}/franka_panda_client"

echo "=== Building franka_panda_client for libfranka ${VERSION} ==="
echo "Image: ${IMAGE}"

# Clean up any leftover container
docker rm -f "${CONTAINER}" 2>/dev/null || true

# Start temporary build container
echo "[1/5] Starting build container..."
docker run -d --name "${CONTAINER}" --entrypoint /bin/bash "${IMAGE}" -c "sleep infinity"

# Copy modified source files
echo "[2/5] Copying source files..."
docker cp "${SRC_CPP}" "${CONTAINER}:${DST_CPP}"
docker cp "${SRC_HPP}" "${CONTAINER}:${DST_HPP}"

# Compile
echo "[3/5] Compiling..."
docker exec "${CONTAINER}" bash -c "cd ${BUILD_DIR} && make franka_panda_client -j4"

# Extract binary
echo "[4/5] Extracting binary..."
mkdir -p "${OUT_DIR}"
docker cp "${CONTAINER}:${BIN}" "${OUT_DIR}/franka_panda_client"

# Clean up
echo "[5/5] Cleaning up..."
docker stop "${CONTAINER}" && docker rm "${CONTAINER}"

echo ""
echo "Done! Binary at: ${OUT_DIR}/franka_panda_client"
ls -la "${OUT_DIR}/franka_panda_client"
