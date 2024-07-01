#!bin/sh
set -e

if [ -z "${MYSQL_HOST}"]; then
  echo "Environment variable MYSQL_HOST not present."
  echo "Valid configuration requires environment variables MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, DATABASE_NAME, and S3_BUCKET. MYSQL_PORT defaults to 3306."
  echo "Aborting."
  exit 1
fi

if [ -z "${MYSQL_PORT}"]; then
  $MYSQL_PORT="3306"
fi

if [ -z "${MYSQL_USER}" ]; then
  echo "Environment variable MYSQL_USER not present."
  echo "Valid configuration requires environment variables MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, DATABASE_NAME, and S3_BUCKET. MYSQL_PORT defaults to 3306."
  echo "Aborting."
  exit 1
fi

if [ -z "${MYSQL_PASSWORD}"]; then
  echo "Environment variable MYSQL_PASSWORD not present."
  echo "Valid configuration requires environment variables MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, DATABASE_NAME, and S3_BUCKET. MYSQL_PORT defaults to 3306."
  echo "Aborting."
  exit 1
fi

if [ -z "${DATABASE_NAME}" ]; then
  echo "Environment variable DATABASE_NAME not present."
  echo "Valid configuration requires environment variables MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, DATABASE_NAME, and S3_BUCKET. MYSQL_PORT defaults to 3306."
  echo "Aborting."
  exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
  echo "Environment variable S3_BUCKET not present."
  echo "Valid configuration requires environment variables MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, DATABASE_NAME, and S3_BUCKET. MYSQL_PORT defaults to 3306."
  echo "Aborting."
  exit 1
fi

date=$(date '+%Y-%m-%d')

filename=/tmp/data/$DATABASE_NAME-$date.gz

if [ -n "$1" ]; then
    filename=/tmp/data/$DATABASE_NAME-$date-$1.gz
fi

echo "Backup $DATABASE_NAME to $S3_BUCKET via $filename"

mysqldump --host=$MYSQL_HOST --port=$MYSQL_PORT -u $MYSQL_USER -p\'$MYSQL_PASSWORD\' --single-transaction --disable-keys --skip-lock-tables --triggers --routines --events --column-statistics=0 $DATABASE_NAME | gzip > $filename

s3cmd put $filename s3://$S3_BUCKET
