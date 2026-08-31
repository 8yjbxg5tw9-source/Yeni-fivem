# 196RP — QURAŞDIRMA TƏLİMATI

> Serveri sıfırdan qurmaq üçün addım-addım bələdçi. Linux istehsal mühiti.

---

## 0. Tələblər

| Element | Tələb |
|---------|-------|
| OS | Linux (Ubuntu 22.04+ tövsiyə) |
| CPU | Güclü single-core (yüksək IPC) |
| RAM | 64 GB |
| Disk | NVMe |
| Şəbəkə | 1 Gbit/s |
| DB | MariaDB 10.6+ |
| Runtime | FiveM server artifacts (Linux) |
| Panel | txAdmin (2FA məcburi) |

---

## 1. Kataloq quruluşu

```
/home/user/Yeni-fivem/
├── server.cfg
├── resources/
│   ├── [core]/      # qbx_core, ox_lib, ox_inventory, ox_target, oxmysql, qbx_skin, pma-voice, txAdmin
│   └── [vr]/        # 196RP custom resursları (bu repo)
├── sql/             # DB schema (00 → 08)
└── docs/            # Bütün sənədlər
```

---

## 2. Core resursların quraşdırılması

`[core]` resursları rəsmi mənbələrdən klonlanır (bu repoya daxil deyil):

```bash
cd resources/[core]
# qbx_core (Qbox) — rəsmi repo
# ox_lib, ox_inventory, ox_target, oxmysql — overwolf
# qbx_skin — Qbox
# pma-voice — rəsmi repo
# txAdmin — FiveM rəsmi
```

> Hər birinin öz `fxmanifest.lua` və asılılıqları var; `server.cfg`-dəki `ensure` qaydasına əməl edin.

---

## 3. Verilənlər bazası

```bash
# MariaDB-ə daxil ol
mysql -u root -p

# Schema-nı icra et (sıra ilə)
source sql/00-database.sql
source sql/01-core.sql
source sql/02-economy.sql
source sql/03-legal.sql
source sql/04-world.sql
source sql/05-criminal.sql
source sql/06-ems.sql
source sql/07-admin-log.sql
source sql/08-phone-media.sql
```

---

## 4. server.cfg konfiqurasiyası

`server.cfg`-də `CHANGEME_` dəyərlərini real dəyərlərlə əvəz edin:

```cfg
sv_licenseKey "REAL_LICENSE"
set steam_webApiKey "REAL_STEAM"
set mysql_connection_string "mysql://USER:PASSWORD@localhost/196rp?charset=utf8mb4"
set discord_webhook "REAL_AUDIT_WEBHOOK"
```

> Bu dəyərlər **git-ə getmir** (.gitignore). `server.cfg.local`-da saxlanılır.

---

## 5. Serverin işə salınması

```bash
# FiveM artifacts ilə
./run.sh +exec server.cfg
```

txAdmin ilk açılışda sizi panelə yönləndirəcək (2FA qurun).

---

## 6. İlk yoxlama (smoke test)

1. Server konsolunda "196RP" mesajlarını görün.
2. DB-yə qoşulur (oxmysql).
3. 27 `vr_` resursu yüklənir (səhvsiz).
4. Whitelist girişi aktivdir.
5. txAdmin-də status sağlamdır.

---

## 7. Whitelist-in aktivləşdirilməsi

1. Discord serveri qurun (sxem `docs/discord/discord-strukturu.md`).
2. Whitelist botunu bağlayın.
3. İlk vətəndaşları `vr_citizenship` cədvəlinə əlavə edin (staff).
4. Sınaq müddəti (14 gün) avtomatik işləyir.

---

## 8. Backup qurulması

```bash
# cron: hər gün 03:00
0 3 * * * mysqldump -u USER -pPASS 196rp > /backups/196rp-$(date +\%F).sql
```

> DR planı: `docs/acilis/dr-plani.md` (RPO 24h, RTO 2h).

---

## 9. Növbəti addımlar

- [ ] Beta (30–50 testçi) — `docs/beta/beta-plani.md`
- [ ] 128 slot stress-test — `docs/beta/stress-test.md`
- [ ] Season 1 açılışı — `docs/acilis/season1-plani.md`

> *Video bələdçi bu addımların vizual qeydidir (ayrıca hazırlanır).*
