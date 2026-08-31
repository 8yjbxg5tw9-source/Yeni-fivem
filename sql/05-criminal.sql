-- ============================================================
-- 05 — KRİMİNAL: dəstələr, qara bazar, narkotik, həbsxana
-- ============================================================
USE `196rp`;

-- 5.1 Dəstələr (vr_criminal)
CREATE TABLE IF NOT EXISTS `vr_gangs` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(64) NOT NULL,
    `leader`      VARCHAR(50) DEFAULT NULL,
    `turf`        TEXT,                       -- turf xəritəsi (JSON)
    `reputation`  INT NOT NULL DEFAULT 0,     -- soyğun pilləsi üçün reputasiya
    `status`      VARCHAR(16) NOT NULL DEFAULT 'active',
    `founded_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.2 Dəstə üzvləri və iyerarxiya
CREATE TABLE IF NOT EXISTS `vr_gang_members` (
    `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`   INT UNSIGNED NOT NULL,
    `citizenid` VARCHAR(50) NOT NULL,
    `rank`      VARCHAR(32) NOT NULL DEFAULT 'member', -- leader/underboss/member
    `joined_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_gang` (`gang_id`),
    KEY `idx_citizenid` (`citizenid`),
    CONSTRAINT `fk_member_gang` FOREIGN KEY (`gang_id`) REFERENCES `vr_gangs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.3 Qara bazar (dinamik qiymətlər)
CREATE TABLE IF NOT EXISTS `vr_blackmarket` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `item`        VARCHAR(64) NOT NULL,
    `price`       DECIMAL(12,2) NOT NULL,
    `risk`        INT NOT NULL DEFAULT 0,       -- polis əməliyyatına görə artır
    `stock`       INT NOT NULL DEFAULT 0,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.4 Narkotik zənciri (yetişdirmə → emal → qablaşdırma → satış)
CREATE TABLE IF NOT EXISTS `vr_drug_operations` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `drug`        VARCHAR(32) NOT NULL,        -- weed/coke/meth/…
    `stage`       VARCHAR(24) NOT NULL,        -- grow/harvest/process/package/sell
    `quantity`    INT NOT NULL DEFAULT 0,
    `quality`     DECIMAL(5,2) NOT NULL DEFAULT 50.00,
    `location_risk` INT NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.5 Oğurluq əşyaları — "istilik" (hot items)
CREATE TABLE IF NOT EXISTS `vr_hot_items` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `item`        VARCHAR(64) NOT NULL,
    `serial`      VARCHAR(64) DEFAULT NULL,
    `stolen_by`   VARCHAR(50) NOT NULL,
    `stolen_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `cool_down_at` TIMESTAMP DEFAULT NULL,      -- satıla biləcəyi zaman
    `sold`        TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`stolen_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.6 Həbsxana məhkumları (vr_prison)
CREATE TABLE IF NOT EXISTS `vr_prisoners` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `char_id`     INT UNSIGNED NOT NULL,
    `sentence_minutes` INT NOT NULL,
    `served_minutes`   INT NOT NULL DEFAULT 0,
    `parole_eligible`  TINYINT(1) NOT NULL DEFAULT 0,
    `bail`         BIGINT DEFAULT NULL,        -- girov məbləği
    `work_credit`  INT NOT NULL DEFAULT 0,     -- emalatxana/mətbəx işi → cəza azalması
    `status`       VARCHAR(16) NOT NULL DEFAULT 'incarcerated', -- incarcerated/paroled/released
    `incarcerated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_char` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5.7 Konvoy və nəqliyyat əməliyyatları
CREATE TABLE IF NOT EXISTS `vr_convoys` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `prisoner_id` INT UNSIGNED NOT NULL,
    `from_loc`    VARCHAR(64) NOT NULL,
    `to_loc`      VARCHAR(64) NOT NULL,
    `escort`      TEXT,                       -- mühafizəçilər (JSON)
    `status`      VARCHAR(16) NOT NULL DEFAULT 'planned', -- planned/transit/completed/compromised
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_prisoner` (`prisoner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
