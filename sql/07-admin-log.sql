-- ============================================================
-- 07 — ADMIN, AUDIT LOG, CƏZA və İCTİMAİ STATİSTİKA
-- ============================================================
USE `196rp`;

-- 7.1 Staff üzvləri
CREATE TABLE IF NOT EXISTS `vr_staff` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `discord_id`  VARCHAR(50) DEFAULT NULL,
    `rank`        VARCHAR(24) NOT NULL DEFAULT 'helper', -- helper/moderator/admin/senior/head/founder
    `probation`   TINYINT(1) NOT NULL DEFAULT 1,         -- 2 həftə sınaq
    `joined_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.2 Admin audit log (ictimai audit üçün)
CREATE TABLE IF NOT EXISTS `vr_audit_log` (
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `staff`       VARCHAR(50) NOT NULL,
    `action`      VARCHAR(64) NOT NULL, -- give_money/give_item/ban/kick/warn/teleport…
    `target`      VARCHAR(50) DEFAULT NULL,
    `detail`      TEXT,                  -- məbləğ/əşya/səbəb
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_staff` (`staff`),
    KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.3 İntizam arxivi (cəzalar)
CREATE TABLE IF NOT EXISTS `vr_punishments` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `type`        VARCHAR(24) NOT NULL, -- warn/tempban/permban
    `reason`      VARCHAR(255) NOT NULL,
    `staff`       VARCHAR(50) NOT NULL,
    `duration`    INT DEFAULT NULL,     -- gün (tempban üçün)
    `expires_at`  TIMESTAMP NULL DEFAULT NULL,
    `active`      TINYINT(1) NOT NULL DEFAULT 1,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.4 Apellyasiyalar
CREATE TABLE IF NOT EXISTS `vr_appeals` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `punishment_id` INT UNSIGNED NOT NULL,
    `citizenid`     VARCHAR(50) NOT NULL,
    `reason`        TEXT,
    `status`        VARCHAR(16) NOT NULL DEFAULT 'pending', -- pending/reviewed/upheld/overturned
    `reviewed_by`   VARCHAR(50) DEFAULT NULL,
    `created_at`    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_punishment` (`punishment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.5 Ban-müqavimət analitikası (cihaz/fingerprint)
CREATE TABLE IF NOT EXISTS `vr_ban_fingerprints` (
    `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`    VARCHAR(50) NOT NULL,
    `fingerprint`  VARCHAR(128) NOT NULL,   -- hash-lənmiş cihaz identifikatoru
    `banned`       TINYINT(1) NOT NULL DEFAULT 0,
    `created_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_fingerprint` (`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.6 İctimai statistika (veb səhifə üçün)
CREATE TABLE IF NOT EXISTS `vr_statistics` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `metric`      VARCHAR(32) NOT NULL, -- online/crime_index/unemployment/tax_revenue/import_export
    `value`       DECIMAL(16,2) NOT NULL,
    `recorded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_metric` (`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
