#!/bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail
shopt -s nullglob

function log_info {
  echo -e $(date '+%Y-%m-%d %T')"\e[1;32m $@\e[0m"
}

function log_error {
  echo -e >&2 $(date +"%Y-%m-%d %T")"\e[1;31m $@\e[0m"
}

process_init_file() {
	local f="$1"; shift
	local mysql=( "$@" )

	case "$f" in
		*.sh)     log_info "$0: running $f"; . "$f" ;;
		*)        echo "$0: ignoring $f" ;;
	esac
	echo done
}

if [ ! -e "/initialized" ]; then
  touch /initialized
  log_info "executing bootstrapping scripts"
  ls /docker-entrypoint-initdb.d/ > /dev/null
  for f in /docker-entrypoint-initdb.d/*; do
    process_init_file "$f"
  done
fi

exec "$@"
