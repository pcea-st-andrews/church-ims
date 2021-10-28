-- rename the users table
ALTER TABLE IF EXISTS accounts_customuser RENAME TO accounts_user;

-- rename sequences
ALTER SEQUENCE IF EXISTS accounts_customuser_id_seq RENAME TO accounts_user_id_seq;
ALTER SEQUENCE IF EXISTS accounts_customuser_groups_id_seq RENAME TO accounts_user_groups_id_seq;
ALTER SEQUENCE IF EXISTS accounts_customuser_user_permissions_id_seq RENAME TO accounts_user_user_permissions_id_seq;

-- delete groups, permissions, content types and migrations
DROP TABLE IF EXISTS accounts_customuser_user_permissions;
DROP TABLE IF EXISTS accounts_customuser_groups;
DROP TABLE IF EXISTS auth_group_permissions;
DROP TABLE IF EXISTS auth_group;
DROP TABLE IF EXISTS auth_permission;
DROP TABLE IF EXISTS django_content_type CASCADE;
DROP TABLE IF EXISTS django_migrations;
