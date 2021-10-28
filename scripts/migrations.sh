#!/bin/bash

# postgres envvars
export PGHOST="$DB_HOST"
export PGPORT="$DB_PORT"
export PGUSER="$DB_USER"
export PGPASSWORD="$DB_PASSWORD"


# other envvars
export DATA_DIR=./data
latest_dump="$DATA_DIR"/latest.dump
PG_DUMP="$DATA_DIR"/"$DB_NAME".dump

# delete previous dumps
if [ -f "$PG_DUMP" ]; then
    rm "$PG_DUMP"
fi

# get the version 0.3.0-alpha of the app and migrations
# delete the data migration in core
git checkout 0.3.0-alpha && git rm core/migrations/0001_initial.py
export OLD_DATABASE_URL="$DATABASE_URL"
export DATABASE_URL="${DATABASE_URL/$DB_NAME/$NEW_DB_NAME}"
dropdb --if-exists "$NEW_DB_NAME" && createdb "$NEW_DB_NAME"
python manage.py migrate --settings=config.settings.base

# Get a fresh copy of the prod data
echo "Restoring $latest_dump"
export DATABASE_URL="$OLD_DATABASE_URL"
dropdb --if-exists "$DB_NAME" && createdb "$DB_NAME"
pg_restore --verbose --clean --no-acl --no-owner -d "$DB_NAME" "$latest_dump"

# migrate data to be compatible with the new version
git checkout 0.3.0-alpha/migrations && git pull
python manage.py migrate
psql -f ./scripts/migrations.sql -d "$DB_NAME"
tables_to_copy=(
    "accounts_user_user_permissions"
    "accounts_user_groups"
    "auth_group_permissions"
    "auth_group"
    "auth_permission"
    "django_content_type"
    "django_migrations"
)
for table in "${tables_to_copy[@]}"; do
    echo "Copying table $table from $NEW_DB_NAME to $DB_NAME"
    pg_dump -t "$table" "$NEW_DB_NAME" | psql "$DB_NAME"
done

# export the data
pg_dump -Fc --no-acl --no-owner "$DB_NAME" > "$PG_DUMP"
pg_restore --verbose --clean --no-acl --no-owner -d "$NEW_DB_NAME" "$PG_DUMP"

# Upload the backup to a Google Cloud storage bucket
if [ "${DB_BACKUPS_STORAGE_BUCKET_NAME}" ]; then
    echo "Uploading the backup"
    gsutil -m rsync -r "$DATA_DIR" gs://"$DB_BACKUPS_STORAGE_BUCKET_NAME"
fi
