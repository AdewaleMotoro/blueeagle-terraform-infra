#!/usr/bin/env bash
#
# scripts/install-hooks.sh
#
# Copies the hooks from .githooks/ into .git/hooks/ so Git actually
# uses them. Git only reads hooks from .git/hooks/ by default — this
# script bridges the gap and makes the hooks version-controlled.
#
# Run this once after cloning the repo:
#   bash scripts/install-hooks.sh

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [ ! -d ".githooks" ]; then
    echo "❌ .githooks/ directory not found at repo root."
    exit 1
fi

echo "Installing git hooks from .githooks/ ..."

for hook in .githooks/*; do
    hook_name="$(basename "$hook")"
    target=".git/hooks/$hook_name"

    cp "$hook" "$target"
    chmod +x "$target"
    echo "  ✅ installed: $hook_name"
done

echo ""
echo "Done. Hooks are now active for this repo."