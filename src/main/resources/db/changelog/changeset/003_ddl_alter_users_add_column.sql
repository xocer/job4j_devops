--liquibase formatted sql
--changeset grishin:add_column
ALTER TABLE users
    ADD COLUMN update_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now();
--rollback ALTER TABLE users DROP COLUMN update_date;
