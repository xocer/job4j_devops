--liquibase formatted sql
--changeset grishin:add_columns
ALTER TABLE users
    ADD COLUMN first_arg VARCHAR (2000),
    ADD COLUMN second_arg VARCHAR (2000),
    ADD COLUMN result VARCHAR (2000)
;

