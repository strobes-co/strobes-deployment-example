#!/bin/bash

COMPOSE_FILE="docker-compose.yml"
TARGET_FILE="./license_keys/signature.txt"
SERVICE_NAME="api"
COMMAND_TO_RUN="./scripts/entrypoint.sh"

echo "Stopping Docker Compose services..."
docker compose -f "$COMPOSE_FILE" down

docker volume rm strobes-deployment-example_cache

sleep 2

echo "Enter the signature (Press ENTER Twice when done):"
> "$TARGET_FILE"

while IFS= read -r line; do
    if [ -z "$line" ]; then
        break
    fi
    echo "$line" >> "$TARGET_FILE"
done

echo "Starting Docker Compose services..."
docker compose -f "$COMPOSE_FILE" up -d

sleep 15

echo "Executing a command, please wait..."
docker compose exec "$SERVICE_NAME" $COMMAND_TO_RUN

echo "License update was successful."
