# 🍃 Docker MongoDB Backup & Restore Scripts

[![Website](https://img.shields.io/badge/Website-hamyartop.com-blue?style=flat-square)](https://hamyartop.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)

A lightweight, production-ready pair of Bash scripts to automate **MongoDB backups** (with Gzip compression and automatic rotation) and perform **interactive restores** directly from a running Docker container.

Developed & Maintained by **[Hamyartop (همیارتاپ)](https://hamyartop.com)**.

---

## ✨ Features

* **Zero Downtime Stream:** Uses `docker exec` with `mongodump --archive --gzip` to stream compressed backups directly to the host machine without creating temporary files inside the container.
* **Smart Retention Policy:** Automatically deletes backups older than N days (default: `7 days`) per specific database so your server disk never fills up.
* **Fail-Safe Execution:** Enabled `set -o pipefail` ensures that failed dumps do not leave corrupted/empty `.gz` archives behind.
* **Container Health Check:** Verifies that the target MongoDB Docker container is actively running before attempting any operation.
* **Interactive Restore CLI:** Lists available backups filtered by database name and restores them via `mongorestore` with full error logging.

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/docker-mongodb-backup-restore.git
cd docker-mongodb-backup-restore
chmod +x mongo_backup.sh restore_mongo.sh
```
### 2. Configuration
Open both mongo_backup.sh and restore_mongo.sh and adjust the configuration variables at the top of the files:

```bash
CONTAINER_NAME="mongodb"
DB_USER="your_admin_user"
DB_PASSWORD="your_secure_password"
BACKUP_DIR="/home/root/db_backups/mongo"
RETENTION_DAYS=7
TARGET_DATABASE="your_db_name"
```
### 3. Usage
📦 Run a Manual Backup:
```bash
./mongo_backup.sh
```

### ⏰ Automate with Cronjob (Recommended):
To run the backup automatically every night at 03:00 AM, open your crontab (crontab -e) and add:

```bash
0 3 * * * /full/path/to/mongo_backup.sh >/dev/null 2>&1
```
### ♻️ Restore a Database Interactively:
```bash
sudo ./restore_mongo.sh
```
The script will prompt you for the database name, display matching .gz backup files with their sizes, and restore the selected archive.

<div dir=“rtl”>

###  راهنمای فارسی (اسکریپت بک‌آپ و ریستور MongoDB در داکر)
این مخزن شامل دو اسکریپت کاربردی به زبان Bash برای پشتیبان‌گیری خودکار (Backup) و بازیابی تعاملی (Restore) دیتابیس MongoDB در محیط Docker است. این ابزار برای سرورهای لینوکسی طراحی شده تا بدون نیاز به ابزارهای پیچیده، امنیت داده‌های شما را تضمین کند.

🔗 مشاهده توضیحات تکمیلی و سایر سورس‌ها در وب‌سایت: Hamyartop.com

### ✨ قابلیت‌ها و ویژگی‌ها
* **فشرده‌سازی مستقیم (Gzip Stream):** بک‌آپ‌ها مستقیماً از داخل کانتینر به صورت فشرده روی هارد سرور استریم می‌شوند و هیچ فضای اضافه‌ای داخل کانتینر اشغال نمی‌شود.

* **پاکسازی خودکار بک‌آپ‌های قدیمی (Retention):** بک‌آپ‌های قدیمی‌تر از ۷ روز (قابل تغییر) به صورت خودکار برای همان دیتابیس حذف می‌شوند تا فضای سرور پر نشود.

* **بررسی وضعیت کانتینر**: قبل از شروع عملیات، روشن بودن کانتینر داکر بررسی می‌شود.
    
* **ریستور تعاملی (Interactive):** در زمان بازیابی، اسکریپت نام دیتابیس را پرسیده، لیست بک‌آپ‌های موجود آن دیتابیس را نمایش می‌دهد و فایل انتخابی شما را ریستور می‌کند.

* **سیستم لاگ‌گیری دقیق**: تمام مراحل، حجم فایل‌ها و خطاهای احتمالی به همراه تاریخ و ساعت در فایل .log ثبت می‌شوند.

### 🛠️ نحوه استفاده
۱. ابتدا به اسکریپت‌ها دسترسی اجرایی بدهید:

```bash
chmod +x mongo_backup.sh restore_mongo.sh
```
۲. متغیرهای بالای هر دو فایل (نام کانتینر، یوزر و پسورد دیتابیس، مسیر ذخیره و نام دیتابیس) را مطابق سرور خود ویرایش کنید.

۳. برای اجرای خودکار روزانه، دستور زیر را در crontab -e قرار دهید (مثال: اجرای هر شب ساعت ۳ بامداد):

```bash
0 3 * * * /path/to/mongo_backup.sh >/dev/null 2>&1
```

۴. برای ریستور کردن دیتابیس کافیست اسکریپت ریستور را اجرا کنید و مراحل را در ترمینال دنبال کنید:

```bash
sudo ./restore_mongo.sh
```
توسعه داده شده توسط همیارتاپ (Hamyartop.com)

</div>

# docker-mongodb-backup-restore
