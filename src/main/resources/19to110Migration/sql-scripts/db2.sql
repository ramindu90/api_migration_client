ALTER TABLE AM_APPLICATION ADD UUID VARCHAR(256) NOT NULL DEFAULT 2;
CALL SYSPROC.ADMIN_CMD('REORG TABLE AM_APPLICATION');
UPDATE AM_APPLICATION SET UUID = HEX(GENERATE_UNIQUE()) where UUID =2;
ALTER TABLE AM_APPLICATION ADD CONSTRAINT UNIQ_UUID_AM_APPLICATION UNIQUE( UUID );
ALTER TABLE AM_SUBSCRIPTION ADD UUID VARCHAR(256) NOT NULL DEFAULT 2;
CALL SYSPROC.ADMIN_CMD('REORG TABLE AM_SUBSCRIPTION');
UPDATE AM_SUBSCRIPTION SET UUID = HEX(GENERATE_UNIQUE()) where UUID =2;
ALTER TABLE AM_SUBSCRIPTION ADD CONSTRAINT UNIQ_UUID_AMSUBSCRIPTION UNIQUE( UUID );
