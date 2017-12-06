#! /bin/bash
set -e

until runuser -l postgres -c 'pg_isready' 2>/dev/null; do
  sleep 1
done

expect -c "spawn boca-config-dbhost localhost; send Y\n; send Y\n; send YES\n; interact;"

echo "Docker startup finished."
