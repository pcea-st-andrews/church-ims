#!/bin/bash

# postgres envvars
export PGHOST="$DB_HOST"
export PGPORT="$DB_PORT"
export PGUSER="$DB_USER"
export PGPASSWORD="$DB_PASSWORD"

# other envvars
export DATA_DIR=./data
latest_dump="$DATA_DIR"/latest.dump

# Create DATA_DIR
if [ ! -d "$DATA_DIR" ]; then
    mkdir -p  "$DATA_DIR"
fi

# Delete the latest dump
if [ -f "$latest_dump" ]; then
    echo "Deleting $latest_dump"
    rm  "$latest_dump"
fi

# Get a copy of the prod database
if [ "$1" == "--create" ]; then
    echo "Creating a backup"
    heroku pg:backups:capture -a "$HEROKU_APP"
fi

echo "Downloading the backup"
heroku pg:backups:download -a "$HEROKU_APP"
mv latest.dump "$DATA_DIR"

# Add a timestamp to the latest backup
timestamp=$(date "+%Y-%m-%dT%H.%M.%S")
backup_name="$DATA_DIR"/"$HEROKU_APP"-"$timestamp".dump
echo "Copying $latest_dump to $backup_name"
cp "$latest_dump" "$backup_name"

# Restoring the backup
echo "Restoring $latest_dump"
dropdb --if-exists "$DB_NAME" && createdb "$DB_NAME"
pg_restore --verbose --clean --no-acl --no-owner -d "$DB_NAME" "$latest_dump"

# Upload the backup to a Google Cloud storage bucket
if [ "${DB_BACKUPS_STORAGE_BUCKET_NAME}" ]; then
    echo "Uploading the backup"
    gsutil -m rsync -r "$DATA_DIR" gs://"$DB_BACKUPS_STORAGE_BUCKET_NAME"
fi
