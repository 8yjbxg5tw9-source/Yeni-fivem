-- ============================================================
-- 09 — ƏLAVƏ SİSTEMLƏR: crafting, təbiət, media, siyasi, kart, referral
-- ============================================================
USE `196rp`;

-- 9.1 Crafting reseptləri
CREATE TABLE IF NOT EXISTS `vr_recipes` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(64) NOT NULL,
    `category`    VARCHAR(32) NOT NULL, -- furniture/food/tools/clothing
    `result_item` VARCHAR(64) NOT NULL,
    `result_amount` INT NOT NULL DEFAULT 1,
    `ingredients` TEXT NOT NULL,        -- JSON: [{item, amount}]
    `required_job` VARCHAR(32) DEFAULT NULL, -- dizayner, aşpaz və s.
    `craft_time`  INT NOT NULL DEFAULT 10,   -- saniyə
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_recipe` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.2 Resayklinq əməliyyatları
CREATE TABLE IF NOT EXISTS `vr_recycling` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `item`        VARCHAR(64) NOT NULL,
    `material_out` VARCHAR(64) NOT NULL,
    `amount`      INT NOT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.3 Ferma sahələri
CREATE TABLE IF NOT EXISTS `vr_farm_plots` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner`       VARCHAR(50) NOT NULL,
    `plot_id`     VARCHAR(64) NOT NULL,
    `crop`        VARCHAR(32) DEFAULT NULL,
    `soil_quality` DECIMAL(5,2) NOT NULL DEFAULT 50.00,
    `irrigation`  DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `planted_at`  TIMESTAMP NULL DEFAULT NULL,
    `ready_at`    TIMESTAMP NULL DEFAULT NULL,
    `disease`     TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_plot` (`plot_id`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.4 Heyvandarlıq (mal-qara)
CREATE TABLE IF NOT EXISTS `vr_livestock` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner`       VARCHAR(50) NOT NULL,
    `animal`      VARCHAR(32) NOT NULL, -- cow/sheep/chicken
    `age_days`    INT NOT NULL DEFAULT 0,
    `health`      DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    `fed_at`      TIMESTAMP NULL DEFAULT NULL,
    `produce_ready` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.5 Elektrik şəbəkəsi statusu (rayon üzrə)
CREATE TABLE IF NOT EXISTS `vr_powergrid` (
    `district`    VARCHAR(64) NOT NULL,
    `powered`     TINYINT(1) NOT NULL DEFAULT 1,
    `sabotage_level` INT NOT NULL DEFAULT 0,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.6 Radiostansiyalar və DJ
CREATE TABLE IF NOT EXISTS `vr_radio_stations` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(64) NOT NULL,
    `frequency`   VARCHAR(16) NOT NULL,
    `dj`          VARCHAR(50) DEFAULT NULL,
    `genre`       VARCHAR(32) DEFAULT NULL,
    `live`        TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_frequency` (`frequency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.7 Məlumat sızması (leak)
CREATE TABLE IF NOT EXISTS `vr_leaks` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `leaker`      VARCHAR(50) DEFAULT NULL,   -- anonim ola bilər
    `title`       VARCHAR(128) NOT NULL,
    `body`        TEXT NOT NULL,
    `target_org`  VARCHAR(64) DEFAULT NULL,
    `published_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.8 Dövlət tenderləri
CREATE TABLE IF NOT EXISTS `vr_tenders` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title`       VARCHAR(128) NOT NULL,
    `agency`      VARCHAR(64) NOT NULL,
    `budget`      BIGINT NOT NULL,
    `deadline`    TIMESTAMP NULL DEFAULT NULL,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'open', -- open/awarded/closed
    `winner`      VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.9 Tender təklifləri
CREATE TABLE IF NOT EXISTS `vr_tender_bids` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tender_id`   INT UNSIGNED NOT NULL,
    `bidder`      VARCHAR(50) NOT NULL,
    `amount`      BIGINT NOT NULL,
    `submitted_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_tender` (`tender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.10 İmpichment işləri
CREATE TABLE IF NOT EXISTS `vr_impeachments` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `official`    VARCHAR(50) NOT NULL,
    `charge`      TEXT NOT NULL,
    `filed_by`    VARCHAR(50) DEFAULT NULL,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'filed', -- filed/investigation/vote/removed/acquitted
    `votes_for`   INT NOT NULL DEFAULT 0,
    `votes_against` INT NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.11 Mitinq icazələri
CREATE TABLE IF NOT EXISTS `vr_rally_permits` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `organizer`   VARCHAR(50) NOT NULL,
    `location`    VARCHAR(128) NOT NULL,
    `datetime`    TIMESTAMP NULL DEFAULT NULL,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'pending', -- pending/approved/denied
    `approved_by` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.12 Debet kartları
CREATE TABLE IF NOT EXISTS `vr_debit_cards` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id`  INT UNSIGNED NOT NULL,
    `card_no`     VARCHAR(20) NOT NULL,
    `pin`         VARCHAR(64) NOT NULL,     -- hash-lənmiş
    `active`      TINYINT(1) NOT NULL DEFAULT 1,
    `duplicate_flag` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_card_no` (`card_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.13 Referral (dost dəvəti)
CREATE TABLE IF NOT EXISTS `vr_referrals` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `referrer`    VARCHAR(50) NOT NULL,
    `code`        VARCHAR(16) NOT NULL,
    `used_by`     VARCHAR(50) DEFAULT NULL,
    `rewarded`    TINYINT(1) NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.14 RP Akademiya (kurs qeydiyyatı)
CREATE TABLE IF NOT EXISTS `vr_academy` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `course`      VARCHAR(32) NOT NULL, -- basics/driving/first_job/chef/mechanic
    `progress`    INT NOT NULL DEFAULT 0,
    `completed`   TINYINT(1) NOT NULL DEFAULT 0,
    `mentor`      VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.15 Avto oğurluq (chop/boosting) əməliyyatları
CREATE TABLE IF NOT EXISTS `vr_cartheft` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `vin`         VARCHAR(64) NOT NULL,
    `action`      VARCHAR(24) NOT NULL, -- steal/chop/boost/vin_change
    `status`      VARCHAR(16) NOT NULL DEFAULT 'active',
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.16 Kibercinayət hədəfləri
CREATE TABLE IF NOT EXISTS `vr_cyber_targets` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(64) NOT NULL,
    `difficulty`  INT NOT NULL DEFAULT 1,
    `reward`      BIGINT NOT NULL,
    `last_hit`    TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9.17 Restart planlayıcısı
CREATE TABLE IF NOT EXISTS `vr_restart_schedule` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `scheduled_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `reason`      VARCHAR(255) DEFAULT NULL,
    `executed`    TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
