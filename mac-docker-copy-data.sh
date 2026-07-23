#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${SQLSERVER_CONTAINER:-sql_server_container}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTINATION="/var/opt/mssql/import/dwh_project/datasets"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker command was not found. Install or start Docker Desktop first."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker Desktop is not running. Start it, wait for the engine, and try again."
  exit 1
fi

if ! docker inspect "$CONTAINER" >/dev/null 2>&1; then
  echo "Container '$CONTAINER' was not found."
  echo "If your container has another name, run:"
  echo "SQLSERVER_CONTAINER=your_container_name bash mac-docker-copy-data.sh"
  exit 1
fi

if [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER")" != "true" ]; then
  echo "Starting $CONTAINER..."
  docker start "$CONTAINER" >/dev/null
fi

echo "Copying course datasets into $CONTAINER..."
docker exec -u 0 "$CONTAINER" mkdir -p "$DESTINATION"
docker cp "$PROJECT_DIR/datasets/." "$CONTAINER:$DESTINATION/"
docker exec -u 0 "$CONTAINER" chmod -R a+rX /var/opt/mssql/import

echo "Dataset copy completed successfully."
echo "Next: follow MAC_DOCKER_SETUP.md and run the SQL files in VS Code."
