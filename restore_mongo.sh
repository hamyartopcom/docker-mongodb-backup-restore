#!/bin/bash

# تنظیمات ثابت (مطابق با اسکریپت بک‌آپ MongoDB شما)
CONTAINER_NAME="mongodb"
DB_USER=""
DB_PASSWORD=""
BACKUP_DIR="/home/root/db_backups/mongo"
LOG_FILE="/home/root/db_backups/mongo_restore.log"

# استفاده از مسیر کامل داکر (برای جلوگیری از خطای command not found هنگام اجرای با sudo)
DOCKER_CMD="/usr/bin/docker"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ۱. دریافت نام دیتابیس مقصد
read -p "Enter the Target Mongo Database name: " TARGET_DATABASE
if [ -z "$TARGET_DATABASE" ]; then
    log "Error: Database name is required."
    exit 1
fi

# ۲. نمایش فایل‌های موجود
echo "------------------------------------------------"
echo "Available Mongo backups in $BACKUP_DIR:"
ls -lh "$BACKUP_DIR" | grep "${TARGET_DATABASE}"
echo "------------------------------------------------"

# ۳. دریافت نام فایل
read -p "Enter the backup filename (e.g. wallpapers_mongo_backup_...): " SELECTED_FILE

if [[ ! "$SELECTED_FILE" == /* ]]; then
    FULL_PATH="$BACKUP_DIR/$SELECTED_FILE"
else
    FULL_PATH="$SELECTED_FILE"
fi

# ۴. بررسی وجود فایل
if [ ! -f "$FULL_PATH" ]; then
    log "Error: File $FULL_PATH not found!"
    exit 1
fi

# ۵. بررسی وضعیت کانتینر
if [ -z "$($DOCKER_CMD ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    log "Error: MongoDB container '$CONTAINER_NAME' is not running!"
    exit 1
fi

log "Starting restoration for Mongo database: $TARGET_DATABASE"

# ۶. عملیات ریستور
# نکته: در MongoDB نیازی به ساخت دستی دیتابیس قبل از ریستور نیست، 
# اگر وجود نداشته باشد به صورت خودکار ساخته می‌شود.
log "Decompressing and Importing data..."

$DOCKER_CMD exec -i $CONTAINER_NAME mongorestore \
    --username "$DB_USER" \
    --password "$DB_PASSWORD" \
    --authenticationDatabase admin \
    --archive \
    --gzip < "$FULL_PATH" 2>> "$LOG_FILE"

# ۷. بررسی نتیجه
if [ $? -eq 0 ]; then
    log "SUCCESS: Mongo database '$TARGET_DATABASE' has been restored."
else
    log "FAILED: Restore failed. See $LOG_FILE for details."
    exit 1
fi
