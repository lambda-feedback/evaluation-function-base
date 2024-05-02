#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Prevent errors in a pipeline from being masked.
set -o pipefail

# Start "wstpserver" in the background if `WSTP_SERVER` environment variable is set to `true`.
# The output of `wstpserver` will be redirected to stdout / stderr.
if [ "$WSTP_SERVER" = "true" ]; then
  wstpserver &
fi

# Execute the command specified via CMD.
exec "$@"