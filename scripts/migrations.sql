-- rename tables
ALTER TABLE IF EXISTS accounts_customuser RENAME TO accounts_user;
ALTER TABLE IF EXISTS accounts_customuser_groups RENAME TO accounts_user_groups;
ALTER TABLE IF EXISTS accounts_customuser_user_permissions RENAME TO accounts_user_user_permissions;

-- rename columns
ALTER TABLE IF EXISTS accounts_user_groups RENAME COLUMN customuser_id TO user_id;
ALTER TABLE IF EXISTS accounts_user_user_permissions RENAME COLUMN customuser_id TO user_id;

-- rename sequences
ALTER SEQUENCE IF EXISTS accounts_customuser_id_seq RENAME TO accounts_user_id_seq;
ALTER SEQUENCE IF EXISTS accounts_customuser_groups_id_seq RENAME TO accounts_user_groups_id_seq;
ALTER SEQUENCE IF EXISTS accounts_customuser_user_permissions_id_seq RENAME TO accounts_user_user_permissions_id_seq;

-- delete migrations and content types
DROP TABLE IF EXISTS django_migrations;
DROP TABLE IF EXISTS django_content_type CASCADE;
