#!/bin/sh
cd "$(dirname "$0")/workbench" || exit 1
export TI60_BUNDLE_ROOT="$(pwd)/../release"
exec python3 -B bootstrap.py
