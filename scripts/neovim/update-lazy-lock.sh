#!/usr/bin/env bash
set -e

# This script copies the lazy-lock.json file from the Neovim config directory
# back to the dotfiles repository.

NVIM_CONFIG_DIR="$HOME/.config/nvim"
DOTFILES_NVIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/nvim"

LAZY_LOCK_FILE="lazy-lock.json"

# Check if the lazy-lock.json file exists in the nvim config directory
if [ -f "$NVIM_CONFIG_DIR/$LAZY_LOCK_FILE" ]; then
    echo "Found $LAZY_LOCK_FILE in $NVIM_CONFIG_DIR"
    echo "Copying to $DOTFILES_NVIM_DIR"
    cp "$NVIM_CONFIG_DIR/$LAZY_LOCK_FILE" "$DOTFILES_NVIM_DIR/$LAZY_LOCK_FILE"
    echo "Done."
else
    echo "No $LAZY_LOCK_FILE found in $NVIM_CONFIG_DIR. Nothing to do."
fi
