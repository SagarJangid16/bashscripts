#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source"          # Directory to be backed up
REMOTE_USER="username"                # Remote server username
REMOTE_HOST="remote.server.com"       # Remote server hostname or IP
REMOTE_DIR="/path/to/backup"          # Directory on the remote server where backup will be stored
LOG_FILE="/var/log/backup.log"        # Log file for backup operation
DATE=$(date +'%Y-%m-%d_%H-%M-%S')

# Function to log messages
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Start of the backup process
log_message "Backup process started at $DATE."

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERROR: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Create a backup archive
BACKUP_ARCHIVE="/tmp/backup_${DATE}.tar.gz"
log_message "Creating backup archive $BACKUP_ARCHIVE from $SOURCE_DIR..."
tar -czf "$BACKUP_ARCHIVE" -C "$SOURCE_DIR" . > /dev/null 2>&1
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to create backup archive."
    exit 1
fi
log_message "Backup archive created successfully."

# Transfer the backup archive to the remote server
log_message "Transferring backup archive to remote server..."
scp "$BACKUP_ARCHIVE" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to transfer backup archive to remote server."
    rm -f "$BACKUP_ARCHIVE"
    exit 1
fi
log_message "Backup archive transferred successfully."

# Clean up local backup archive
rm -f "$BACKUP_ARCHIVE"

# End of the backup process
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
log_message "Backup process completed at $DATE."

exit 0
