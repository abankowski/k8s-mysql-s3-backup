#!/bin/sh
set -e

if [ -z "${S3_BUCKET}" ]; then
  echo "Environment variable S3_BUCKET not present."
  echo "Valid configuration requires environment variables MONGODB_URI, DATABASE_NAME, and S3_BUCKET"
  echo "Aborting."
  exit 1
fi

OLDER_THAN_DAYS=${OLDER_THAN_DAYS:-7}
OLDER_THAN_DATE=$(date -d "${OLDER_THAN_DAYS} days ago" +%Y-%m-%d)

s3cmd ls --list-md s3://$S3_BUCKET/ | while read -r line; do
  FILE_DATE=$(echo "$line" | awk '{print $1}')
  FILE_PATH=$(echo "$line" | awk '{print $5}')

  if [[ $FILE_DATE \< $OLDER_THAN_DATE ]]; then
    echo "Deleting $FILE_PATH (Last modified: $FILE_DATE)"
    s3cmd del "$FILE_PATH"
  else
    echo "Skipping $FILE_PATH"
  fi
done
