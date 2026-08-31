-- ============================================================
-- 04 — DÜNYA: şirkətlər, əmlak, nəqliyyat, işlər
-- ============================================================
USE `196rp`;

-- 4.1 Şirkətlər (vr_companies)
CREATE TABLE IF NOT EXISTS `vr_companies` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(64) NOT NULL,
    `type`        VARCHAR(32) NOT NULL, -- restaurant/dealership/logistics/clothing/nightclub/security/media/farm/mine/estate/clinic/law
    `owner`       VARCHAR(50) DEFAULT NULL,   -- citizenid
    `registry_no` VARCHAR(32) NOT NULL,       -- şirkət reyestr nömrəsi
    `capital`     BIGINT NOT NULL DEFAULT 0,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'active',
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_registry` (`registry_no`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.2 Şirkət işçiləri və maaş
CREATE TABLE IF NOT EXISTS `vr_company_employees` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `company_id`  INT UNSIGNED NOT NULL,
    `citizenid`   VARCHAR(50) NOT NULL,
    `role`        VARCHAR(32) NOT NULL DEFAULT 'employee', -- employee/manager/ceo
    `salary`      BIGINT NOT NULL DEFAULT 0,
    `contract_id` INT UNSIGNED DEFAULT NULL,
    `hired_at`    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_company` (`company_id`),
    KEY `idx_citizenid` (`citizenid`),
    CONSTRAINT `fk_emp_company` FOREIGN KEY (`company_id`) REFERENCES `vr_companies`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.3 Şirkət stoku
CREATE TABLE IF NOT EXISTS `vr_company_stock` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `company_id`  INT UNSIGNED NOT NULL,
    `item`        VARCHAR(64) NOT NULL,
    `amount`      INT NOT NULL DEFAULT 0,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_company` (`company_id`),
    CONSTRAINT `fk_stock_company` FOREIGN KEY (`company_id`) REFERENCES `vr_companies`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.4 Şirkət qeydiyyat kitabı (reyestr) — tam tarixçə
CREATE TABLE IF NOT EXISTS `vr_company_registry` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `company_id`  INT UNSIGNED NOT NULL,
    `entry_type`  VARCHAR(32) NOT NULL, -- founded/stock_sale/branch/advert/audit
    `details`     TEXT,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_company` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.5 Əmlak (vr_property)
CREATE TABLE IF NOT EXISTS `vr_properties` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `property_id` VARCHAR(64) NOT NULL,           -- oyun identifikatoru
    `type`        VARCHAR(24) NOT NULL,           -- motel/apartment/house/villa/commercial
    `owner`       VARCHAR(50) DEFAULT NULL,
    `price`       BIGINT NOT NULL DEFAULT 0,
    `mortgage`    BIGINT NOT NULL DEFAULT 0,
    `mortgage_remaining` BIGINT NOT NULL DEFAULT 0,
    `rented_to`   VARCHAR(50) DEFAULT NULL,
    `neighborhood` VARCHAR(64) DEFAULT NULL,      -- kriminal səviyyəyə bağlı bazar
    `status`      VARCHAR(16) NOT NULL DEFAULT 'available',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_property` (`property_id`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.6 Kommunal fakturalar
CREATE TABLE IF NOT EXISTS `vr_utilities` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `property_id` VARCHAR(64) NOT NULL,
    `utility`     VARCHAR(16) NOT NULL, -- electricity/water/gas
    `amount`      BIGINT NOT NULL,
    `period`      DATE NOT NULL,
    `paid`        TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_property` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.7 Nəqliyyat — VIN tarixçəsi (vr_vehicles)
CREATE TABLE IF NOT EXISTS `vr_vehicle_records` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `plate`      VARCHAR(16) NOT NULL,
    `vin`        VARCHAR(64) NOT NULL,
    `model`      VARCHAR(64) NOT NULL,
    `owner`      VARCHAR(50) DEFAULT NULL,
    `mileage`    BIGINT NOT NULL DEFAULT 0,
    `condition`  DECIMAL(5,2) NOT NULL DEFAULT 100.00, -- aşınma
    `total_loss` TINYINT(1) NOT NULL DEFAULT 0,
    `insurance`  VARCHAR(32) DEFAULT NULL,
    `registered_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_vin` (`vin`),
    KEY `idx_plate` (`plate`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.8 VIN hadisələri (qəza, sahib dəyişmə, texniki baxış)
CREATE TABLE IF NOT EXISTS `vr_vehicle_events` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `vin`         VARCHAR(64) NOT NULL,
    `event_type`  VARCHAR(24) NOT NULL, -- accident/ownership/registration/inspection/impound
    `details`     TEXT,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_vin` (`vin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.9 Qaraj və parking (vr_garages)
CREATE TABLE IF NOT EXISTS `vr_garages` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `garage_id`   VARCHAR(64) NOT NULL,
    `owner`       VARCHAR(50) DEFAULT NULL,
    `shared_with` TEXT,                          -- müştərək qaraj (JSON)
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_garage` (`garage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4.10 Mülki işlər / peşələr (vr_jobs)
CREATE TABLE IF NOT EXISTS `vr_jobs` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `job`         VARCHAR(32) NOT NULL, -- taxi/bus/courier/farmer/miner/mechanic/lawyer/journalist…
    `grade`       INT NOT NULL DEFAULT 0,
    `certified`   TINYINT(1) NOT NULL DEFAULT 0, -- attestasiya
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
