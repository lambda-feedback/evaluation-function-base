#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Prevent errors in a pipeline from being masked.
set -o pipefail

# start the aws lambda RIE if AWS_LAMBDA_RIE is set, and AWS_LAMBDA_RUNTIME_API is not
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ] && [ -n "${AWS_LAMBDA_RIE}" ]; then
  exec aws-lambda-rie "$@"
else
  exec "$@"
fi
