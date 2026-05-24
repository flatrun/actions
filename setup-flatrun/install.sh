#!/usr/bin/env bash
set -euo pipefail

VERSION="${INPUT_VERSION:-}"
INSTALL_DIR="${INPUT_INSTALL_DIR:-}"
REPOSITORY="${INPUT_REPOSITORY:-flatrun/cli}"

if [ -z "$VERSION" ]; then
  echo "::error::version input is required" >&2
  exit 1
fi

VERSION="${VERSION#v}"

case "$(uname -s)" in
  Linux)  OS=linux ;;
  Darwin) OS=darwin ;;
  *) echo "::error::Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
  x86_64|amd64)   ARCH=amd64 ;;
  aarch64|arm64)  ARCH=arm64 ;;
  *) echo "::error::Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

if [ -z "$INSTALL_DIR" ]; then
  if [ -n "${RUNNER_TOOL_CACHE:-}" ]; then
    INSTALL_DIR="${RUNNER_TOOL_CACHE}/flatrun/${VERSION}/${ARCH}"
  else
    INSTALL_DIR="${HOME}/.flatrun/bin"
  fi
fi

mkdir -p "$INSTALL_DIR"
WORK="$(mktemp -d)"
cd "$WORK"

echo "Downloading flatrun v${VERSION} for ${OS}/${ARCH} from ${REPOSITORY}..."
if ! gh release download "v${VERSION}" \
      --repo "$REPOSITORY" \
      --pattern "*${OS}*${ARCH}*"; then
  echo "::error::Failed to download flatrun v${VERSION} for ${OS}/${ARCH} from ${REPOSITORY}." >&2
  echo "::error::See the gh error above. Confirm the release exists and is accessible: gh release view v${VERSION} --repo ${REPOSITORY}" >&2
  exit 1
fi

shopt -s nullglob
for archive in *.tar.gz *.tgz; do tar -xzf "$archive" && rm -f "$archive"; done
for archive in *.zip; do unzip -q "$archive" && rm -f "$archive"; done
shopt -u nullglob

BIN="$(find . -type f -name 'flatrun' -print -quit)"
if [ -z "$BIN" ]; then
  BIN="$(find . -type f \( -name 'flatrun-*' -o -name 'flatrun_*' \) \
          ! -name '*.sha256' ! -name '*.sha512' \
          ! -name '*.sig'    ! -name '*.asc'    \
          ! -name '*.tar.gz' ! -name '*.tgz' ! -name '*.zip' \
          -print -quit)"
fi
if [ -z "$BIN" ]; then
  echo "::error::Could not find a 'flatrun' binary in the release artifacts:" >&2
  find . -maxdepth 2 -type f >&2
  exit 1
fi

install -m 0755 "$BIN" "${INSTALL_DIR}/flatrun"
echo "${INSTALL_DIR}" >> "$GITHUB_PATH"
echo "path=${INSTALL_DIR}/flatrun" >> "$GITHUB_OUTPUT"

echo "Installed flatrun v${VERSION} to ${INSTALL_DIR}/flatrun"
"${INSTALL_DIR}/flatrun" version || true
