#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [[ ! -d /bitbucket-home/shared ]]
then
  echo "Creating /bitbucket-home/shared"
  mkdir -p /bitbucket-home/shared
fi

if [[ ! -s /bitbucket-home/shared/bitbucket.properties ]]
then
  echo "Linking /config/bitbucket.properties to /bitbucket-home/shared/bitbucket.properties"
  ln -s /config/bitbucket.properties /bitbucket-home/shared/bitbucket.properties
fi

echo "Starting Bitbucket"
exec /bitbucket/bin/start-bitbucket.sh run --no-search
