#!/usr/bin/env bash
# Run a script under MuJoCo's `mjpython` (required on macOS for the passive
# viewer) with uv's managed Python. uv's interpreter links libpython via @rpath,
# which mjpython's app bundle can't resolve, so point dyld at the real LIBDIR.
#
# Usage (from anywhere):
#   scripts/mjpython.sh scripts/infer_policy.py --walking pretrained/alpha_walking.onnx \
#       --standing pretrained/alpha_stand.onnx --new-cmd-obs
set -euo pipefail
cd "$(dirname "$0")/.."
unset VIRTUAL_ENV  # ignore any other project's active venv

if [[ "$(uname)" != "Darwin" ]]; then
  exec uv run python "$@"
fi

LIBDIR="$(uv run python -c 'import sysconfig; print(sysconfig.get_config_var("LIBDIR"))')"
DYLD_LIBRARY_PATH="$LIBDIR${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}" exec uv run mjpython "$@"
