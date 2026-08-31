-- ============================================================
-- 196RP — TƏK FAYLLI TAM QURAŞDIRMA (phpMyAdmin üçün)
-- Bu faylı phpMyAdmin-də İMPORT edin. Hamısı bir dəfəyə qurulur.
-- ============================================================

-- ============================================================
-- 196RP — VELMORA RESPUBLİKASI
-- Verilənlər bazası yaradılması
-- Mühərrik: MariaDB (oxmysql) · UTF-8 (utf8mb4)
-- ============================================================

CREATE DATABASE IF NOT EXISTS `196rp`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `196rp`;

-- Qbox core öz cədvəllərini (players, player_vehicles, owned_properties və s.)
-- avtomatik yaradır. Aşağıdakı fayllar 196RP-nin ƏLAVƏ (vr_) cədvəlləridir.
-- İcra qaydası: 01 → 02 → ... → 14


-- ============================================================
-- 01 — CORE: konfiq, personaj, identiklik, vətəndaşlıq
-- ============================================================

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

-- ============================================================
-- 02 — İQTİSADİYYAT: hesablar, əməliyyatlar, vergi, büdcə, birja
-- ============================================================

-- 2.1 Bank hesabları (vr_banking)
CREATE TABLE IF NOT EXISTS `vr_accounts` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `type`        VARCHAR(16)  NOT NULL DEFAULT 'personal', -- personal/company/government
    `owner`       VARCHAR(50)  NOT NULL,                     -- citizenid və ya company id
    `account_no`  VARCHAR(20)  NOT NULL,                     -- IBAN analoqu (Velmora)
    `balance`     BIGINT       NOT NULL DEFAULT 0,
    `is_frozen`   TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_account_no` (`account_no`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.2 Əməliyyatlar (bütün pul hərəkəti — audit üçün)
CREATE TABLE IF NOT EXISTS `vr_transactions` (
    `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` INT UNSIGNED NOT NULL,
    `type`       VARCHAR(24)  NOT NULL, -- deposit/withdraw/transfer/salary/tax/fine/income
    `amount`     BIGINT       NOT NULL,
    `counterparty` VARCHAR(50) DEFAULT NULL,
    `note`       VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_account` (`account_id`),
    KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.3 Kreditlər (bank dərinliyi)
CREATE TABLE IF NOT EXISTS `vr_loans` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id`  INT UNSIGNED NOT NULL,
    `principal`   BIGINT       NOT NULL,
    `remaining`   BIGINT       NOT NULL,
    `interest_pct` DECIMAL(5,2) NOT NULL DEFAULT 5.00,
    `installments_total` INT NOT NULL DEFAULT 12,
    `installments_paid`  INT NOT NULL DEFAULT 0,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'active', -- active/paid/defaulted
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.4 Dövlət büdcəsi (vergi → xəzinə → maaş fondu)
CREATE TABLE IF NOT EXISTS `vr_budget` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category`    VARCHAR(32) NOT NULL,             -- police/ems/fire/municipality/transport/other
    `allocation`  BIGINT NOT NULL DEFAULT 0,        -- ayrılmış fond
    `spent`       BIGINT NOT NULL DEFAULT 0,
    `period`      VARCHAR(16) NOT NULL DEFAULT 'weekly',
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.5 Xəzinə (vergi yığımı)
CREATE TABLE IF NOT EXISTS `vr_treasury` (
    `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tax_type` VARCHAR(32) NOT NULL,               -- income/property/sales/import/fine
    `amount`  BIGINT NOT NULL,
    `collected_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_type` (`tax_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.6 Birja (Velmora Birjası)
CREATE TABLE IF NOT EXISTS `vr_stocks` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `symbol`      VARCHAR(8)   NOT NULL,           -- şirkət simvolu
    `company_id`  INT UNSIGNED DEFAULT NULL,
    `price`       DECIMAL(12,2) NOT NULL,
    `total_shares` BIGINT NOT NULL DEFAULT 0,
    `updated_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_symbol` (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.7 Səhm portfeli
CREATE TABLE IF NOT EXISTS `vr_stock_holdings` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`  VARCHAR(50) NOT NULL,
    `symbol`     VARCHAR(8)  NOT NULL,
    `shares`     BIGINT      NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.8 Dinamik qiymətlər (yanacaq/ərzaq/dərman)
CREATE TABLE IF NOT EXISTS `vr_prices` (
    `item`       VARCHAR(64) NOT NULL,
    `price`      DECIMAL(12,2) NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.9 İnflyasiya monitorinqi (7 günlük)
CREATE TABLE IF NOT EXISTS `vr_inflation_log` (
    `id`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `day`      DATE NOT NULL,
    `avg_price_index` DECIMAL(12,2) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_day` (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.10 İqtisadi anomaliya flag-ları
CREATE TABLE IF NOT EXISTS `vr_economy_flags` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`  VARCHAR(50) NOT NULL,
    `reason`     VARCHAR(128) NOT NULL,
    `data`       TEXT,
    `resolved`   TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 03 — HÜQUQ: lisenziyalar, polis (MDT/sübut), məhkəmə
-- ============================================================

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

-- ============================================================
-- 04 — DÜNYA: şirkətlər, əmlak, nəqliyyat, işlər
-- ============================================================

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

-- ============================================================
-- 05 — KRİMİNAL: dəstələr, qara bazar, narkotik, həbsxana
-- ============================================================

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

-- ============================================================
-- 06 — TİBB: yaralar, qan bankı, asılılıq, yanğın
-- ============================================================

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

-- ============================================================
-- 07 — ADMIN, AUDIT LOG, CƏZA və İCTİMAİ STATİSTİKA
-- ============================================================

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

-- ============================================================
-- 08 — TELEFON, MEDİA, SİYASİ, DİGƏR
-- ============================================================

-- 8.1 Telefon mesajları (SMS)
CREATE TABLE IF NOT EXISTS `vr_messages` (
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `from`        VARCHAR(24) NOT NULL,   -- telefon nömrəsi
    `to`          VARCHAR(24) NOT NULL,
    `body`        TEXT NOT NULL,
    `read`        TINYINT(1) NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_to` (`to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.2 Kontaktlar
CREATE TABLE IF NOT EXISTS `vr_contacts` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner`      VARCHAR(24) NOT NULL,
    `name`       VARCHAR(64) NOT NULL,
    `number`     VARCHAR(24) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.3 Sosial media (Twatter analoqu) — "Kvatter"
CREATE TABLE IF NOT EXISTS `vr_social_posts` (
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `author`      VARCHAR(50) NOT NULL,
    `body`        TEXT NOT NULL,
    `image`       VARCHAR(255) DEFAULT NULL,
    `likes`       INT NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.4 Xəbərlər (Dövlət Xəbər Xidməti + oyunçu qəzetləri)
CREATE TABLE IF NOT EXISTS `vr_news` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `outlet`      VARCHAR(64) NOT NULL,   -- dövlət / qəzet adı
    `title`       VARCHAR(128) NOT NULL,
    `body`        TEXT NOT NULL,
    `author`      VARCHAR(50) DEFAULT NULL,
    `official`    TINYINT(1) NOT NULL DEFAULT 0, -- dövlət rəsmi elanı
    `published_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_outlet` (`outlet`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.5 Reklam lövhələri icarəsi
CREATE TABLE IF NOT EXISTS `vr_billboards` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `location`   VARCHAR(128) NOT NULL,
    `renter`     VARCHAR(50) DEFAULT NULL,
    `content`    VARCHAR(255) DEFAULT NULL,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.6 Siyasi — parlament və qanunlar
CREATE TABLE IF NOT EXISTS `vr_laws` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title`       VARCHAR(128) NOT NULL,
    `body`        TEXT NOT NULL,
    `status`      VARCHAR(16) NOT NULL DEFAULT 'proposed', -- proposed/passed/repealed
    `effect`      TEXT,                    -- mexaniki təsir (məs. tonirovka qadağası → cərimə)
    `passed_at`   TIMESTAMP NULL DEFAULT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.7 Seçki və referendum
CREATE TABLE IF NOT EXISTS `vr_elections` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title`       VARCHAR(128) NOT NULL,
    `type`        VARCHAR(24) NOT NULL, -- election/referendum
    `status`      VARCHAR(16) NOT NULL DEFAULT 'upcoming', -- upcoming/active/closed
    `start_at`    TIMESTAMP NULL DEFAULT NULL,
    `end_at`      TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.8 Səslər
CREATE TABLE IF NOT EXISTS `vr_votes` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `election_id` INT UNSIGNED NOT NULL,
    `citizenid`   VARCHAR(50) NOT NULL,
    `choice`      VARCHAR(128) NOT NULL,
    `cast_at`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_election` (`election_id`),
    UNIQUE KEY `uq_voter` (`election_id`, `citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.9 Vəzifəli şəxslərin əmlak bəyannaməsi
CREATE TABLE IF NOT EXISTS `vr_asset_declarations` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid`   VARCHAR(50) NOT NULL,
    `declaration` TEXT NOT NULL,            -- əmlak siyahısı (JSON)
    `luxury`      TINYINT(1) NOT NULL DEFAULT 0, -- lüks əmlak reyestri
    `submitted_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.10 Ev heyvanları
CREATE TABLE IF NOT EXISTS `vr_pets` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner`       VARCHAR(50) NOT NULL,
    `name`        VARCHAR(64) NOT NULL,
    `species`     VARCHAR(16) NOT NULL, -- dog/cat
    `hunger`      DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    `health`      DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8.11 Poçt sistemi
CREATE TABLE IF NOT EXISTS `vr_mail` (
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `from`        VARCHAR(50) NOT NULL,
    `to`          VARCHAR(50) NOT NULL,
    `type`        VARCHAR(16) NOT NULL DEFAULT 'letter', -- letter/parcel
    `content`     TEXT,
    `item`        VARCHAR(64) DEFAULT NULL, -- bağlama əşyası
    `delivered`   TINYINT(1) NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_to` (`to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 09 — ƏLAVƏ SİSTEMLƏR: crafting, təbiət, media, siyasi, kart, referral
-- ============================================================

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
    `scheduled_at` TIMESTAMP NOT NULL,
    `reason`      VARCHAR(255) DEFAULT NULL,
    `executed`    TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- QBX_CORE cədvəlləri (qbx_core.sql)
-- Qbox framework-ün tələb etdiyi əsas cədvəllər
-- ============================================================

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `phone_number` VARCHAR(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `players`
ADD COLUMN IF NOT EXISTS `last_logged_out` timestamp NULL DEFAULT NULL AFTER `last_updated`,
MODIFY COLUMN `name` varchar(255) NOT NULL COLLATE utf8mb4_unicode_ci;

ALTER TABLE `players`
ADD COLUMN IF NOT EXISTS `userId` INT UNSIGNED DEFAULT NULL AFTER `id`;

CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `player_groups` (
  `citizenid` VARCHAR(50) NOT NULL,
  `group` VARCHAR(50) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `grade` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`citizenid`, `type`, `group`),
  CONSTRAINT `fk_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- QBX_VEHICLES cədvəli (qbx_vehicles/vehicles.sql)
-- ============================================================

CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(15) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `coords` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
