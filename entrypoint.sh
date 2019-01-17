#!/bin/bash
set -e
source ${PG_APP_HOME}/functions

[[ ${DEBUG} == true ]] && set -x

# allow arguments to be passed to postgres
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == postgres || ${1} == $(which postgres) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

trap_handler() {
  # Handling Kill Signal
  # Process will be awaited until postgres related processes are stoped.
  echo "Stopping PostgreSQL by Kill Signal $1"
  /usr/bin/sudo -u postgres ${PG_BINDIR}/pg_ctl -D ${PG_DATADIR} stop
}

# default behaviour is to launch postgres
if [[ -z ${1} ]]; then
  map_uidgid

  create_datadir
  create_certdir
  create_logdir
  create_rundir

  set_resolvconf_perms

  configure_postgresql

  configure_tuning

  # Start PostgreSQL as a Daemon Process
  echo "Starting PostgreSQL ${PG_VERSION}..."
  /usr/bin/sudo -u postgres ${PG_BINDIR}/pg_ctl -D ${PG_DATADIR} start

  # Record PID of Postgres Process
  trap "trap_handler SIGINT" SIGINT
  trap "trap_handler SIGTERM" SIGTERM
  trap "trap_handler SIGKILL" SIGKILL

  # We'll Keep this Process while 'postgres' related processes are alive.
  while [[ $(ps -Af | grep 'postgres' | wc -l) > 2 ]]; do
    wait
  done
else
  exec "$@"
fi
