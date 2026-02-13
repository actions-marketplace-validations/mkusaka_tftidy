#!/bin/sh
set -e

TYPE="$1"
DRY_RUN="$2"
VERBOSE="$3"
NORMALIZE_WHITESPACE="$4"
DIRECTORY="$5"

ARGS=""

if [ -n "$TYPE" ]; then
  ARGS="$ARGS --type $TYPE"
fi

if [ "$DRY_RUN" = "true" ]; then
  ARGS="$ARGS --dry-run"
fi

if [ "$VERBOSE" = "true" ]; then
  ARGS="$ARGS --verbose"
fi

if [ "$NORMALIZE_WHITESPACE" = "true" ]; then
  ARGS="$ARGS --normalize-whitespace"
fi

# Resolve directory relative to GitHub workspace
if [ -n "$DIRECTORY" ] && [ "$DIRECTORY" != "." ]; then
  TARGET="${GITHUB_WORKSPACE}/${DIRECTORY}"
else
  TARGET="${GITHUB_WORKSPACE:-.}"
fi

# shellcheck disable=SC2086
exec tftidy $ARGS "$TARGET"
