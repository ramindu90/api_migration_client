SELECT DISTINCT constraint_name FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE table_name='AM_APP_KEY_DOMAIN_MAPPING'
ALTER TABLE AM_APP_KEY_DOMAIN_MAPPING DROP FOREIGN KEY <temp_key_name>;