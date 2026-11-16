#!/bin/sh
# Start Chatwoot on Railway: prepare the database, then run the Rails web
# server and the Sidekiq worker in one container. Both share /app/storage
# (a Railway volume attaches to one service only), and the container exits
# when either process stops, so Railway restarts the whole service.
set -eu
cd /app

# Fixed settings. Any of them can be overridden with a service variable.
export PORT="${PORT:-3000}"
export ACTIVE_STORAGE_SERVICE="${ACTIVE_STORAGE_SERVICE:-local}"
export ENABLE_ACCOUNT_SIGNUP="${ENABLE_ACCOUNT_SIGNUP:-false}"
export LOG_LEVEL="${LOG_LEVEL:-info}"
export FORCE_SSL="${FORCE_SSL:-false}"   # Railway's edge already serves HTTPS

if [ -z "${SECRET_KEY_BASE:-}" ] || [ -z "${DATABASE_URL:-}" ] || [ -z "${REDIS_URL:-}" ]; then
  echo "SECRET_KEY_BASE, DATABASE_URL and REDIS_URL must be set." >&2
  exit 1
fi

mkdir -p /app/storage /app/tmp/pids
rm -f /app/tmp/pids/server.pid

echo "Waiting for Postgres..."
until pg_isready -q -d "$DATABASE_URL"; do sleep 2; done

echo "Preparing the database (creates or migrates it)..."
POSTGRES_STATEMENT_TIMEOUT=600s bundle exec rails db:chatwoot_prepare

bundle exec sidekiq -C config/sidekiq.yml &
SIDEKIQ_PID=$!
bundle exec rails server -p "$PORT" -b '::' &
WEB_PID=$!

# Stop both processes, give them up to 25 s to finish, then kill anything
# left (Sidekiq's health-check subprocess is re-parented to this script).
shutdown() {
  kill -TERM "$WEB_PID" "$SIDEKIQ_PID" 2>/dev/null || true
  i=0
  while [ "$i" -lt 25 ] && { kill -0 "$WEB_PID" 2>/dev/null || kill -0 "$SIDEKIQ_PID" 2>/dev/null; }; do
    sleep 1
    i=$((i + 1))
  done
  kill -KILL -1 2>/dev/null || true
  exit "$1"
}
trap 'shutdown 0' TERM INT

while kill -0 "$WEB_PID" 2>/dev/null && kill -0 "$SIDEKIQ_PID" 2>/dev/null; do
  sleep 5
done

echo "A Chatwoot process stopped; exiting so Railway restarts the service." >&2
shutdown 1
