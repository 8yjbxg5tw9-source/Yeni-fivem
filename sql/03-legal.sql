-- ============================================================
-- 03 — HÜQUQ: lisenziyalar, polis (MDT/sübut), məhkəmə
-- ============================================================
USE `196rp`;

-- 3.1 Lisenziyalar və sənədlər (vr_licenses)
CREATE TABLE IF NOT EXISTS `vr_licenses` (
    `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`   INT UNSIGNED NOT NULL,
    `type`      VARCHAR(32) NOT NULL, -- driver/weapon/hunting/fishing/business/pilot/professional
    `points`    INT NOT NULL DEFAULT 0,     -- sürücülük xalları (cərimə)
    `status`    VARCHAR(16) NOT NULL DEFAULT 'active', -- active/suspended/revoked
    `issued_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATE DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`),
    KEY `idx_type` (`type`),
    CONSTRAINT `fk_license_char` FOREIGN KEY (`char_id`) REFERENCES `vr_characters`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.2 Cərimələr (sürücülük və digər)
CREATE TABLE IF NOT EXISTS `vr_fines` (
    `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`   INT UNSIGNED NOT NULL,
    `officer`   VARCHAR(50) DEFAULT NULL,
    `reason`    VARCHAR(255) NOT NULL,
    `amount`    BIGINT NOT NULL,
    `paid`      TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.3 MDT — şəxs axtarışı, BOLO, protokollar (vr_police)
CREATE TABLE IF NOT EXISTS `vr_mdt_records` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`    INT UNSIGNED DEFAULT NULL,     -- VRN ilə əlaqə
    `record_type` VARCHAR(32) NOT NULL,          -- person/vehicle/warrant/bolo/report
    `title`      VARCHAR(128) NOT NULL,
    `body`       TEXT,
    `status`     VARCHAR(16) NOT NULL DEFAULT 'open',
    `officer`    VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`),
    KEY `idx_type` (`record_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.4 Sübutlar (barmaq izi, DNT, giliz, qan, kamera)
CREATE TABLE IF NOT EXISTS `vr_evidence` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `case_id`     VARCHAR(64) DEFAULT NULL,
    `evidence_type` VARCHAR(24) NOT NULL, -- fingerprint/dna/shell/blood/bodycam/cctv
    `char_id`     INT UNSIGNED DEFAULT NULL,
    `data`        TEXT,                     -- analiz məlumatı (JSON)
    `quality`     DECIMAL(5,2) NOT NULL DEFAULT 100.00, -- zamanla düşür
    `collected_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_case` (`case_id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.5 Ballistika bazası (lisenziyalı silahların seriya/giliz izi)
CREATE TABLE IF NOT EXISTS `vr_ballistics` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `weapon_serial` VARCHAR(64) NOT NULL,
    `owner_char_id` INT UNSIGNED DEFAULT NULL,
    `registered` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_serial` (`weapon_serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.6 Məhkəmə — işlər və docket (vr_court)
CREATE TABLE IF NOT EXISTS `vr_court_cases` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `case_no`     VARCHAR(32) NOT NULL,
    `type`        VARCHAR(24) NOT NULL, -- criminal/civil/administrative
    `instance`    VARCHAR(24) NOT NULL DEFAULT 'lower', -- lower/appeal/supreme
    `plaintiff`   VARCHAR(50) DEFAULT NULL,
    `defendant`   VARCHAR(50) DEFAULT NULL,
    `judge`       VARCHAR(50) DEFAULT NULL,
    `prosecutor`  VARCHAR(50) DEFAULT NULL,
    `defender`    VARCHAR(50) DEFAULT NULL,
    `jury`        TINYINT(1) NOT NULL DEFAULT 0,
    `status`      VARCHAR(24) NOT NULL DEFAULT 'pending', -- pending/hearing/decided/appealed
    `verdict`     TEXT,
    `transcript`  TEXT,                    -- yüklənə bilən transkript
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_case_no` (`case_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.7 Notariat müqavilələri
CREATE TABLE IF NOT EXISTS `vr_contracts` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `contract_no` VARCHAR(32) NOT NULL,
    `type`        VARCHAR(32) NOT NULL, -- sale/rent/employment/loan/will
    `parties`     TEXT NOT NULL,        -- tərəflər (JSON)
    `terms`       TEXT NOT NULL,        -- şərtlər
    `notary`      VARCHAR(50) DEFAULT NULL,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'active',
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_contract_no` (`contract_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3.8 Vətəndaşlıq Reyestri hadisələri (nikah/boşanma/ölüm/vəsiyyət)
CREATE TABLE IF NOT EXISTS `vr_civil_records` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`     INT UNSIGNED NOT NULL,
    `record_type` VARCHAR(24) NOT NULL, -- marriage/divorce/death/will/birth
    `details`     TEXT,
    `registered_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
