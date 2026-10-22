#!/bin/bash
set -euo pipefail

: "${DB_USER:?DB_USER environment variable is not set}"
: "${DB_PASSWORD:?DB_PASSWORD environment variable is not set}"

SOURCE_DB="ShopDB"
RESERVE_DB="ShopDBReserve"
DEV_DB="ShopDBDevelopment"

export MYSQL_PWD="${DB_PASSWORD}"

MYSQL=(mysql -u"${DB_USER}")
MYSQLDUMP=(mysqldump -u"${DB_USER}")

echo "Creating full backup of ${SOURCE_DB} and restoring it to ${RESERVE_DB}..."
"${MYSQLDUMP[@]}" "${SOURCE_DB}" | "${MYSQL[@]}" "${RESERVE_DB}"

echo "Copying data from ${SOURCE_DB} to ${DEV_DB} (schema is not copied)..."
"${MYSQLDUMP[@]}" --no-create-info --skip-triggers "${SOURCE_DB}" | "${MYSQL[@]}" "${DEV_DB}"

echo "Backup and restore completed successfully."
