-- ============================================================
-- 01 — CORE: konfiq, personaj, identiklik, vətəndaşlıq
-- ============================================================
USE `196rp`;

-- 1.1 Server konfiqi (vr_core / vr_lore)
CREATE TABLE IF NOT EXISTS `vr_config` (
    `key`   VARCHAR(64)  NOT NULL,
    `value` TEXT         NOT NULL,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.2 Personajlar (vr_identity)
CREATE TABLE IF NOT EXISTS `vr_characters` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50)  NOT NULL,          -- Qbox player citizenid
    `charid`      INT          NOT NULL,          -- Qbox charid (slot)
    `vrn`         VARCHAR(20)  NOT NULL,          -- Vətəndaş Reyestr Nömrəsi VR-#########
    `firstname`   VARCHAR(64)  NOT NULL,
    `lastname`    VARCHAR(64)  NOT NULL,
    `birthdate`   DATE         NOT NULL,
    `birthplace`  VARCHAR(32)  NOT NULL DEFAULT 'Asterra',
    `gender`      VARCHAR(16)  NOT NULL DEFAULT 'male',
    `bloodtype`   VARCHAR(8)   NOT NULL DEFAULT 'O+',
    `phone`       VARCHAR(24)  DEFAULT NULL,
    `story`       TEXT,                            -- personaj hekayəsi
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'alive', -- alive / dead / ck
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_vrn` (`vrn`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.3 Şəxsi profil (aidiyyətli qurumlar baxa bilər)
CREATE TABLE IF NOT EXISTS `vr_profile` (
    `char_id`        INT UNSIGNED NOT NULL,
    `criminal_record` TEXT,                        -- cinayət keçmişi (JSON)
    `medical_card`    TEXT,                        -- tibbi kart (JSON)
    `credit_score`    INT NOT NULL DEFAULT 500,    -- kredit reytinqi (KYC)
    `kyc_status`      VARCHAR(16) NOT NULL DEFAULT 'none',
    PRIMARY KEY (`char_id`),
    CONSTRAINT `fk_profile_char` FOREIGN KEY (`char_id`) REFERENCES `vr_characters`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.4 Vətəndaşlıq səviyyələri və whitelist (vr_whitelist)
CREATE TABLE IF NOT EXISTS `vr_citizenship` (
    `citizenid`   VARCHAR(50) NOT NULL,
    `level`       VARCHAR(32) NOT NULL DEFAULT 'temporary', -- temporary/citizen/trusted/veteran
    `mentor_id`   VARCHAR(50) DEFAULT NULL,                 -- veteran citizenid
    `trial_until` DATE DEFAULT NULL,                        -- sınaq sonu
    `joined_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.5 Alt-personaj aşkarlama logu (özlərarası köçürmə analizi)
CREATE TABLE IF NOT EXISTS `vr_altpersonaj_log` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `from_char`   INT UNSIGNED NOT NULL,
    `to_char`     INT UNSIGNED NOT NULL,
    `item`        VARCHAR(64)  NOT NULL,
    `amount`      INT          NOT NULL,
    `flagged`     TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
