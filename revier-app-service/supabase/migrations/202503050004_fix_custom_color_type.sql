-- Fix custom_color column type in animal_filter and animal tables
-- The value "4282339765" is out of range for type integer (max value: 2,147,483,647)
-- Changing the column type to BIGINT

-- Alter the column type in animal_filter table
ALTER TABLE animal_filter ALTER COLUMN custom_color TYPE BIGINT;

-- Also fix the same column in the animal table
ALTER TABLE animal ALTER COLUMN custom_color TYPE BIGINT; 