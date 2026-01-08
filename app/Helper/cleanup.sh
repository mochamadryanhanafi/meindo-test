#!/bin/bash

# Konfigurasi
LOG_DIR="/var/www/html/storage/logs"
RETENTION_DAYS=7

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR not found."
    exit 1
fi

echo "Starting log rotation for logs older than $RETENTION_DAYS days in $LOG_DIR..."


find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS | while read log_file; do
    
    tar -czf "${log_file}.tar.gz" -C "$(dirname "$log_file")" "$(basename "$log_file")"
    
    if [ $? -eq 0 ]; then
        rm "$log_file"
        echo "[SUCCESS] Compressed and removed: $log_file"
    else
        echo "[ERROR] Failed to compress: $log_file"
    fi
done

echo "Log rotation completed."