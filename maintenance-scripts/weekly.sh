#!/bin/bash

# Set timezone to IST (Asia/Kolkata)
export TZ='Asia/Kolkata'

# Configuration
SLACK_WEBHOOK_URL=""  # Replace with your Slack webhook URL
WORKING_DIR=""  # Replace with your docker-compose directory
CLIENT_NAME=""  # Replace with your customer or client name
LOG_FILE="/var/log/maintenance.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S IST')

# Logging functions
log_info() {
    echo "[$TIMESTAMP] INFO: $1" >> "$LOG_FILE"
    echo "INFO: $1"
}

log_warn() {
    echo "[$TIMESTAMP] WARN: $1" >> "$LOG_FILE"
    echo "WARN: $1"
}

log_error() {
    echo "[$TIMESTAMP] ERROR: $1" >> "$LOG_FILE"
    echo "ERROR: $1"
}

# Function to send Slack notification
send_slack_notification() {
    local message="$1"
    curl -s -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$message\"}" \
        "$SLACK_WEBHOOK_URL" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_info "Slack notification sent: $message"
    else
        log_error "Failed to send Slack notification: $message"
    fi
}

# Start maintenance
log_info "Starting weekly maintenance activity"
send_slack_notification ":hammer_and_wrench: Starting weekly maintenance activity for client $CLIENT_NAME"

# Step 1: Navigate to path and execute docker-compose down
log_info "Navigating to $WORKING_DIR"
cd "$WORKING_DIR" || {
    log_error "Failed to navigate to $WORKING_DIR"
    send_slack_notification ":warning: Maintenance failed for client $CLIENT_NAME: Could not navigate to $WORKING_DIR"
    exit 1
}

log_info "Executing docker-compose down"
docker-compose down >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log_info "docker-compose down completed successfully"
else
    log_error "docker-compose down failed"
    send_slack_notification ":warning: Maintenance failed for client $CLIENT_NAME: docker-compose down error"
    exit 1
fi

# Step 2: Remove specified Docker volumes
VOLUMES="strobes-deployment-example_cache strobes-deployment-example_esdata strobes-deployment-example_rabbitmq_data strobes-deployment-example_rabbitmq_tri_data"
for volume in $VOLUMES; do
    log_info "Removing Docker volume: $volume"
    docker volume rm "$volume" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_info "Volume $volume removed successfully"
    else
        log_warn "Volume $volume removal failed or volume not found"
    fi
done

# Step 3: Check disk space
log_info "Checking disk space"
DISK_SPACE=$(df -h / | tail -n 1)  # Capture disk space for root filesystem
if [ $? -eq 0 ]; then
    TOTAL=$(echo "$DISK_SPACE" | awk '{print $2}')
    USED=$(echo "$DISK_SPACE" | awk '{print $3}')
    AVAILABLE=$(echo "$DISK_SPACE" | awk '{print $4}')
    PERCENT=$(echo "$DISK_SPACE" | awk '{print $5}')
    DISK_SPACE_FORMATTED="Total: \`$TOTAL\`, Used: \`$USED\`, Available: \`$AVAILABLE\`, Used%: \`$PERCENT\`"
    log_info "Disk space checked successfully: $DISK_SPACE"
else
    log_error "Failed to check disk space"
    send_slack_notification ":warning: Maintenance warning for client $CLIENT_NAME: Failed to check disk space"
    DISK_SPACE_FORMATTED="Failed to retrieve disk space"
fi

# Step 4: Execute docker-compose up -d
log_info "Executing docker-compose up -d"
docker-compose up -d >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log_info "docker-compose up -d completed successfully"
else
    log_error "docker-compose up -d failed"
    send_slack_notification ":warning: Maintenance failed for client $CLIENT_NAME: docker-compose up -d error"
    exit 1
fi

# Step 5: Check if API is up using a health check
HEALTH_CHECK_URL="http://localhost/api/v2/deployment_mode/"
MAX_ATTEMPTS=30  # 5 minutes / 10 seconds = 30 attempts
ATTEMPT=1
log_info "Checking API health at $HEALTH_CHECK_URL (max $MAX_ATTEMPTS attempts)"
while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_CHECK_URL")
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    if [ "$HTTP_STATUS" -eq 200 ]; then
        HEALTH_STATUS=":large_green_circle: Healthy"
        log_info "API health check successful (HTTP $HTTP_STATUS) on attempt $ATTEMPT"
        break
    else
        HEALTH_STATUS=":warning: Unhealthy (Error Code: $HTTP_STATUS)"
        log_warn "API health check failed (HTTP $HTTP_STATUS) on attempt $ATTEMPT"
        if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
            log_error "API health check failed after $MAX_ATTEMPTS attempts"
            send_slack_notification ":warning: Maintenance failed for client $CLIENT_NAME: API health check did not return 200 after 5 minutes"
            exit 1
        fi
        sleep 10
    fi
    ATTEMPT=$((ATTEMPT + 1))
done
# Step 6: Notify maintenance completion
log_info "Weekly maintenance activity completed successfully for client $CLIENT_NAME"
send_slack_notification ":white_check_mark: Weekly maintenance activity completed successfully for client $CLIENT_NAME\n\n:floppy_disk: Disk Space: $DISK_SPACE_FORMATTED\n\n:stethoscope: API Health Status: $HEALTH_STATUS"

exit 0