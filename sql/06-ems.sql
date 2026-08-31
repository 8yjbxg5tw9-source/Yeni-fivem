-- ============================================================
-- 06 — TİBB: yaralar, qan bankı, asılılıq, yanğın
-- ============================================================
USE `196rp`;

-- 6.1 Tibbi kart / yaralar (vr_ems)
CREATE TABLE IF NOT EXISTS `vr_injuries` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`     INT UNSIGNED NOT NULL,
    `injury_type` VARCHAR(24) NOT NULL, -- gunshot/cut/burn/trauma
    `severity`    INT NOT NULL DEFAULT 1,
    `bleeding`    TINYINT(1) NOT NULL DEFAULT 0, -- qan itkisi timeri
    `permanent_scar` TINYINT(1) NOT NULL DEFAULT 0,
    `treated`     TINYINT(1) NOT NULL DEFAULT 0,
    `treated_by`  VARCHAR(50) DEFAULT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6.2 Qan bankı (donor RP)
CREATE TABLE IF NOT EXISTS `vr_bloodbank` (
    `blood_type` VARCHAR(8) NOT NULL,
    `units`      INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`blood_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6.3 Donor qeydləri
CREATE TABLE IF NOT EXISTS `vr_donations` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`    INT UNSIGNED NOT NULL,
    `blood_type` VARCHAR(8) NOT NULL,
    `units`      INT NOT NULL DEFAULT 1,
    `donated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6.4 Asılılıq və reabilitasiya
CREATE TABLE IF NOT EXISTS `vr_addictions` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`     INT UNSIGNED NOT NULL,
    `substance`   VARCHAR(32) NOT NULL,
    `level`       INT NOT NULL DEFAULT 0,       -- asılılıq səviyyəsi
    `rehab_status` VARCHAR(16) NOT NULL DEFAULT 'none',
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6.5 Reanimasiya pəncərəsi / ölüm qeydləri
CREATE TABLE IF NOT EXISTS `vr_deaths` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`     INT UNSIGNED NOT NULL,
    `cause`       VARCHAR(64) NOT NULL,
    `revivable`   TINYINT(1) NOT NULL DEFAULT 1,
    `revived`     TINYINT(1) NOT NULL DEFAULT 0,
    `death_time`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6.6 Yanğın hadisələri (vr_fire)
CREATE TABLE IF NOT EXISTS `vr_fires` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `location`    VARCHAR(128) NOT NULL,
    `fire_type`   VARCHAR(24) NOT NULL, -- building/vehicle/gas_leak
    `spread`      DECIMAL(5,2) NOT NULL DEFAULT 0.00, -- yayılma səviyyəsi
    `contained`   TINYINT(1) NOT NULL DEFAULT 0,
    `reported_by` VARCHAR(50) DEFAULT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
