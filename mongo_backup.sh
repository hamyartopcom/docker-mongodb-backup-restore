#!/bin/bash

# تنظیمات
CONTAINER_NAME="mongodb"
DB_USER=""
DB_PASSWORD=""
BACKUP_DIR="/home/root/db_backups/mongo"
RETENTION_DAYS=7
LOG_FILE="/home/root/db_backups/mongo_backup.log"

# نام دیتابیس مورد نظر را اینجا وارد کنید
TARGET_DATABASE="wallpapers" 


# فعال کردن pipefail
set -o pipefail

# ایجاد پوشه بک‌آپ
mkdir -p "$BACKUP_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Starting MongoDB backup for database: $TARGET_DATABASE"

# تولید نام فایل (نام دیتابیس به اول فایل اضافه شد)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="$BACKUP_DIR/${TARGET_DATABASE}_mongo_backup_$TIMESTAMP.gz"

# بررسی وجود و در حال اجرا بودن کانتینر
if [ -z "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    log "Error: MongoDB container '$CONTAINER_NAME' is not running!"
    exit 1
fi

# گرفتن بک‌آپ با mongodump
# اضافه شدن سوییچ --db برای انتخاب دیتابیس خاص
docker exec $CONTAINER_NAME mongodump \
    --username "$DB_USER" \
    --password "$DB_PASSWORD" \
    --authenticationDatabase admin \
    --db "$TARGET_DATABASE" \
    --archive \
    --gzip > "$FILENAME"

# بررسی نتیجه
if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "$FILENAME" | cut -f1)
    log "Backup successful: $FILENAME (Size: $FILE_SIZE)"
    
    # حذف بک‌آپ‌های قدیمی فقط برای همین دیتابیس
    find "$BACKUP_DIR" -name "${TARGET_DATABASE}_mongo_backup_*.gz" -type f -mtime +$RETENTION_DAYS -delete
    log "Old backups for $TARGET_DATABASE cleaned up."
else
    log "Backup failed! Check connection or database name."
    rm -f "$FILENAME"
    exit 1
fi

log "Process completed for $TARGET_DATABASE."
