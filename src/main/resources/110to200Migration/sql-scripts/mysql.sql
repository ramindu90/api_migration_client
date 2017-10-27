ALTER TABLE AM_API  ADD COLUMN API_TIER VARCHAR(256);
ALTER TABLE AM_APPLICATION MODIFY COLUMN UUID VARCHAR(254);
ALTER TABLE AM_SUBSCRIPTION MODIFY COLUMN UUID VARCHAR(254);
ALTER TABLE AM_SUBSCRIPTION_KEY_MAPPING MODIFY COLUMN KEY_TYPE VARCHAR(255) NOT NULL;
ALTER TABLE AM_APPLICATION_KEY_MAPPING MODIFY COLUMN KEY_TYPE VARCHAR(255) NOT NULL;

CREATE TABLE IF NOT EXISTS AM_ALERT_TYPES (
            ALERT_TYPE_ID INTEGER AUTO_INCREMENT,
            ALERT_TYPE_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL,
            PRIMARY KEY (ALERT_TYPE_ID)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_ALERT_TYPES_VALUES (
            ALERT_TYPE_ID INTEGER,
            USER_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL ,
            CONSTRAINT AM_ALERT_TYPES_VALUES_CONSTRAINT UNIQUE (ALERT_TYPE_ID,USER_NAME,STAKE_HOLDER)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_ALERT_EMAILLIST (
	    EMAIL_LIST_ID INTEGER AUTO_INCREMENT,
            USER_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL ,
            PRIMARY KEY (EMAIL_LIST_ID),
    	    CONSTRAINT AM_ALERT_EMAILLIST_CONSTRAINT UNIQUE (EMAIL_LIST_ID,USER_NAME,STAKE_HOLDER)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS  AM_ALERT_EMAILLIST_DETAILS (
            EMAIL_LIST_ID INTEGER,
	    EMAIL VARCHAR(255),
            CONSTRAINT AM_ALERT_EMAILLIST_DETAILS_CONSTRAINT UNIQUE (EMAIL_LIST_ID,EMAIL)
)ENGINE = INNODB;

INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalResponseTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalBackendTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalRequestsPerMin', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('RequestPatternChanged', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('UnusualIPAccessAlert', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRefreshAlert', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('FrequentTierHittingAlert', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalTierUsage', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('healthAvailabilityPerMin', 'publisher');



-- AM Throttling tables --

CREATE TABLE IF NOT EXISTS AM_POLICY_SUBSCRIPTION (
            POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
            NAME VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
            TENANT_ID INT(11) NOT NULL,
            DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
            QUOTA_TYPE VARCHAR(25) NOT NULL,
            QUOTA INT(11) NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL,
            UNIT_TIME INT(11) NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            RATE_LIMIT_COUNT INT(11) NULL DEFAULT NULL,
            RATE_LIMIT_TIME_UNIT VARCHAR(25) NULL DEFAULT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
	    CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
            STOP_ON_QUOTA_REACH BOOLEAN NOT NULL DEFAULT 0,
            BILLING_PLAN VARCHAR(20) NOT NULL,
            UUID VARCHAR(254),
            PRIMARY KEY (POLICY_ID),
            UNIQUE INDEX AM_POLICY_SUBSCRIPTION_NAME_TENANT (NAME, TENANT_ID),
            UNIQUE (UUID)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AM_POLICY_APPLICATION (
            POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
            NAME VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
            TENANT_ID INT(11) NOT NULL,
            DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
            QUOTA_TYPE VARCHAR(25) NOT NULL,
            QUOTA INT(11) NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
            UNIT_TIME INT(11) NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
	    CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
	          UUID VARCHAR(254),
            PRIMARY KEY (POLICY_ID),
            UNIQUE INDEX APP_NAME_TENANT (NAME, TENANT_ID),
            UNIQUE (UUID)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AM_POLICY_HARD_THROTTLING (
            POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
            NAME VARCHAR(255) NOT NULL,
            TENANT_ID INT(11) NOT NULL,
            DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
            QUOTA_TYPE VARCHAR(25) NOT NULL,
            QUOTA INT(11) NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
            UNIT_TIME INT(11) NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
            PRIMARY KEY (POLICY_ID),
            UNIQUE INDEX POLICY_HARD_NAME_TENANT (NAME, TENANT_ID)
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS AM_API_THROTTLE_POLICY (
            POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
            NAME VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
            TENANT_ID INT(11) NOT NULL,
            DESCRIPTION VARCHAR (1024),
            DEFAULT_QUOTA_TYPE VARCHAR(25) NOT NULL,
            DEFAULT_QUOTA INTEGER NOT NULL,
            DEFAULT_QUOTA_UNIT VARCHAR(10) NULL,
            DEFAULT_UNIT_TIME INTEGER NOT NULL,
            DEFAULT_TIME_UNIT VARCHAR(25) NOT NULL,
            APPLICABLE_LEVEL VARCHAR(25) NOT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
            UUID VARCHAR(254),
            PRIMARY KEY (POLICY_ID),
            UNIQUE INDEX API_NAME_TENANT (NAME, TENANT_ID),
            UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_CONDITION_GROUP (
            CONDITION_GROUP_ID INTEGER NOT NULL AUTO_INCREMENT,
            POLICY_ID INTEGER NOT NULL,
            QUOTA_TYPE VARCHAR(25),
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            DESCRIPTION VARCHAR (1024) NULL DEFAULT NULL,
            PRIMARY KEY (CONDITION_GROUP_ID),
            FOREIGN KEY (POLICY_ID) REFERENCES AM_API_THROTTLE_POLICY(POLICY_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_QUERY_PARAMETER_CONDITION (
            QUERY_PARAMETER_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            PARAMETER_NAME VARCHAR(255) DEFAULT NULL,
            PARAMETER_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_PARAM_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (QUERY_PARAMETER_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_HEADER_FIELD_CONDITION (
            HEADER_FIELD_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            HEADER_FIELD_NAME VARCHAR(255) DEFAULT NULL,
            HEADER_FIELD_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_HEADER_FIELD_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (HEADER_FIELD_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_JWT_CLAIM_CONDITION (
            JWT_CLAIM_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR(512) DEFAULT NULL,
            CLAIM_ATTRIB VARCHAR(1024) DEFAULT NULL,
	    IS_CLAIM_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (JWT_CLAIM_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_IP_CONDITION (
  AM_IP_CONDITION_ID INT NOT NULL AUTO_INCREMENT,
  STARTING_IP VARCHAR(45) NULL,
  ENDING_IP VARCHAR(45) NULL,
  SPECIFIC_IP VARCHAR(45) NULL,
  WITHIN_IP_RANGE BOOLEAN DEFAULT 1,
  CONDITION_GROUP_ID INT NULL,
  PRIMARY KEY (AM_IP_CONDITION_ID),
  INDEX fk_AM_IP_CONDITION_1_idx (CONDITION_GROUP_ID ASC),  CONSTRAINT fk_AM_IP_CONDITION_1    FOREIGN KEY (CONDITION_GROUP_ID)
    REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)   ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS AM_POLICY_GLOBAL (
            POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
            NAME VARCHAR(255) NOT NULL,
            KEY_TEMPLATE VARCHAR(512) NOT NULL,
            TENANT_ID INT(11) NOT NULL,
            DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
            SIDDHI_QUERY BLOB DEFAULT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
            UUID VARCHAR(254),
            PRIMARY KEY (POLICY_ID),
            UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_THROTTLE_TIER_PERMISSIONS (
  THROTTLE_TIER_PERMISSIONS_ID INT NOT NULL AUTO_INCREMENT,
  TIER VARCHAR(50) NULL,
  PERMISSIONS_TYPE VARCHAR(50) NULL,
  ROLES VARCHAR(512) NULL,
  TENANT_ID INT(11) NULL,
  PRIMARY KEY (THROTTLE_TIER_PERMISSIONS_ID))
ENGINE = InnoDB;

CREATE TABLE `AM_BLOCK_CONDITIONS` (
  `CONDITION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TYPE` varchar(45) DEFAULT NULL,
  `VALUE` varchar(45) DEFAULT NULL,
  `ENABLED` varchar(45) DEFAULT NULL,
  `DOMAIN` varchar(45) DEFAULT NULL,
  `UUID` VARCHAR(254),
  PRIMARY KEY (`CONDITION_ID`),
  UNIQUE (`UUID`)
) ENGINE=InnoDB;

-- End of API-MGT Tables --

-- Performance indexes start--

create index IDX_ITS_LMT on IDN_THRIFT_SESSION (LAST_MODIFIED_TIME);
create index IDX_IOAT_AT on IDN_OAUTH2_ACCESS_TOKEN (ACCESS_TOKEN);
create index IDX_IOAT_UT on IDN_OAUTH2_ACCESS_TOKEN (USER_TYPE);
create index IDX_AAI_CTX on AM_API (CONTEXT);
create index IDX_AAKM_CK on AM_APPLICATION_KEY_MAPPING (CONSUMER_KEY);
create index IDX_AAUM_AI on AM_API_URL_MAPPING (API_ID);
create index IDX_AAUM_TT on AM_API_URL_MAPPING (THROTTLING_TIER);
create index IDX_AATP_DQT on AM_API_THROTTLE_POLICY (DEFAULT_QUOTA_TYPE);
create index IDX_ACG_QT on AM_CONDITION_GROUP (QUOTA_TYPE);
create index IDX_APS_QT on AM_POLICY_SUBSCRIPTION (QUOTA_TYPE);
create index IDX_AS_AITIAI on AM_SUBSCRIPTION (API_ID,TIER_ID,APPLICATION_ID);
create index IDX_APA_QT on AM_POLICY_APPLICATION (QUOTA_TYPE);
create index IDX_AA_AT_CB on AM_APPLICATION (APPLICATION_TIER,CREATED_BY);

-- Performance indexes end--
