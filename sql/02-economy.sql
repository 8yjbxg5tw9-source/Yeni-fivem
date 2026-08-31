-- ============================================================
-- 02 — İQTİSADİYYAT: hesablar, əməliyyatlar, vergi, büdcə, birja
-- ============================================================
USE `196rp`;

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
