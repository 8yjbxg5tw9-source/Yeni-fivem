# 196RP — DISCORD STRUKTUR SXEMİ və BOTLAR

> Discord serverin rəsmi icma və idarəetmə mərkəzidir.
> Hər dövlət qurumunun öz kanal bölməsi (qravitasiyası) var.

---

## 1. Kateqoriya və kanal sxemi

```
196RP — VELMORA RESPUBLİKASI
│
├── 📢 MƏLUMAT
│   ├── #elanlar          (yalnız rəsmi elanlar)
│   ├── #patch-changelog  (hər yeniləmə)
│   ├── #qaydalar         (yalnız oxuma)
│   ├── #whitelist-melu   (whitelist necə keçirilir)
│   └── #veb-sayt         (link)
│
├── 🏛️ DÖVLƏT QURUMLARI
│   ├── #polis-melu
│   ├── #ems-melu
│   ├── #yangin-melu
│   ├── #mehkeme-melu
│   ├── #belediyye-melu
│   ├── #vergi-gomruk-melu
│   ├── #nedliyyat-melu
│   ├── #emek-sahibkarlıq-melu
│   ├── #dovlet-xeber-melu
│   ├── #notariat-melu
│   └── #secki-komissiyasi-melu
│
├── 🗳️ WHITELIST
│   ├── #whitelist-murac   (müraciət)
│   ├── #whitelist-veziyyet (statuslar)
│   └── #whitelist-musahibe (müsahibə otaqları)
│
├── 🎫 DƏSTƏK və İDARƏ
│   ├── #ticket            (dəstək bileti)
│   ├── #report            (OOC report)
│   ├── #apellyasiya       (cəza etirazı)
│   └── #ombudsman         (müstəqil nəzarət)
│
├── 🎬 MEDİA və İCMA
│   ├── #media-klipler     (klip paylaşımı)
│   ├── #xeberler          (oyunçu qəzetləri)
│   ├── #radio-dj          (DJ və radio)
│   ├── #reklam            (şirkət reklamları)
│   └── #icma-sohbet
│
├── 🧑‍💼 STAFF (gizli)
│   ├── #staff-elanlar
│   ├── #staff-diskussiya
│   ├── #intizam-arxiv     (yalnız staff)
│   ├── #audit-log         (bot avtomatik log)
│   └── #eskalasiya        (qərar matrisi)
│
└── 🤖 BOTLAR
    ├── #bot-log           (avtomatik loglar)
    └── #bot-status        (server onlayn statusu)
```

---

## 2. Rollar (iyerarxiya)

| Rol | Açıqlama |
|-----|----------|
| Founder | Sahib, ən yüksək səlahiyyət |
| Head Admin | İdarə rəhbəri |
| Senior Admin | Yüksək admin |
| Admin | Admin |
| Moderator | Moderasiya |
| Helper | Köməkçi |
| Ombudsman | Müstəqil nəzarətçi (staff-dan ayrı) |
| Veteran | Nümunəvi oyunçu (mentor ola bilər) |
| Etibarlı | Təcrübəli oyunçu |
| Vətəndaş | Tam üzv |
| Müvəqqəti Vətəndaş | Sınaqda |

---

## 3. Botlar

| Bot | Funksiya |
|-----|----------|
| **Whitelist bot** | Formanı toplayır, RP testini qiymətləndirir, status izləyir |
| **Log bot** | Server/əməliyyat loglarını kanala yazır (audit) |
| **Kadr bot** | Staff müraciəti, növbə (shift), performans izləmə |
| **Oyun-statistika bot** | Onlayn sayı, cinayət indeksi, iqtisadi qrafiklər (veb ilə sinxron) |

---

## 4. Ticket və Report axını

1. Oyunçu `#ticket` ilə ümumi dəstək, `#report` ilə OOC şikayət açır.
2. Bot bilet yaradır və müvafiq staff-a bildirir.
3. Report zamanı klip/sübut tələb olunur.
4. Nəticə `#intizam-arxiv`-də (yalnız staff) qeyd olunur.
5. Etiraz → `#apellyasiya` → `#ombudsman`.

---

## 5. Qravitasiya prinsipi (dövlət qurumları)

- Hər dövlət qurumunun öz kanal bölməsi var; qurum rəhbəri orada IC elanlar verə bilər.
- IC elanlarla OOC elanlar ayrı tutulur (IC kanallarda OOC yoxdur).
- Qurum kanallarına giriş yalnız qurum üzvlərinədir (rol əsaslı).

---

> *Bu sxem Addım 4-də Discord server qurulanda baza kimi istifadə olunacaq.*
