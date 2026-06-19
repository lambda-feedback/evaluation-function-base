#!/bin/bash
# Wolfram Licensing

if [ ! -e /root/.Wolfram/Licensing/mathpass ]; then
  /usr/local/Wolfram/Wolfram/14.3/Executables/WolframKernel <<EOF
  $NAME
  $COMPANY_NAME
  $LICENSE_KEY
  Quit[]
EOF
  if [ ! -e /root/.Wolfram/Licensing/mathpass ]; then
    echo "ERROR: Wolfram licensing failed. Check that NAME, COMPANY_NAME, and LICENSE_KEY environment variables are set correctly." >&2
    exit 1
  fi
fi

# Exit immediately if a command exits with a non-zero status.
set -e

# Prevent errors in a pipeline from being masked.
set -o pipefail

# Start "wstpserver" in the background if `WSTP_SERVER` environment variable is set to `true`.
# The output of `wstpserver` will be redirected to stdout / stderr.
if [ "$WSTP_SERVER" = "true" ]; then
  wstpserver &
fi

# start the aws lambda RIE if AWS_LAMBDA_RIE is set, and AWS_LAMBDA_RUNTIME_API is not
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ] && [ -n "${AWS_LAMBDA_RIE}" ]; then
  exec aws-lambda-rie "$@"
else
  exec "$@"
fi
