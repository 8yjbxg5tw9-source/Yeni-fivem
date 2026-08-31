-- ============================================================
-- 08 — TELEFON, MEDİA, SİYASİ, DİGƏR
-- ============================================================
USE `196rp`;

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
