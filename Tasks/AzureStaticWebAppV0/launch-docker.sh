#!/usr/bin/env bash
set -euo pipefail

# SWA_DOCKER_PULL expected values (case-insensitive): "always", "missing", "never"
pull_option="${SWA_DOCKER_PULL:-}"
pull_option_lc="$(echo "${pull_option}" | tr '[:upper:]' '[:lower:]')"

case "${pull_option_lc}" in
  always)
    pull_flag="--pull=always"
    ;;
  missing)
    pull_flag="--pull=missing"
    ;;
  never|"")
    pull_flag=""
    ;;
  *)
    echo "Warning: unknown SWA_DOCKER_PULL value '${pull_option}'; defaulting to '--pull=always'" 1>&2
    pull_flag="--pull=always"
    ;;
esac

if [ -n "${pull_flag}" ]; then
  docker run \
    --env-file ./env.list \
    ${pull_flag} \
    -v "$SWA_WORKING_DIR:$SWA_WORKSPACE_DIR" \
    "$SWA_DEPLOYMENT_CLIENT" \
    ./bin/staticsites/StaticSitesClient run
else
  docker run \
    --env-file ./env.list \
    -v "$SWA_WORKING_DIR:$SWA_WORKSPACE_DIR" \
    "$SWA_DEPLOYMENT_CLIENT" \
    ./bin/staticsites/StaticSitesClient run
fi
