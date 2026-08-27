#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

NU_DIR="$HOME/Library/Application Support/nushell"
mkdir -p ~/.config "$NU_DIR"

ln -snfv "$PWD"/{nvim,ghostty,yazi} ~/.config/
ln -snfv "$PWD/nushell/config.nu" "$NU_DIR/config.nu"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install it first: https://brew.sh" >&2
    exit 1
fi

brew bundle --file Brewfile

echo "Successful installation"
