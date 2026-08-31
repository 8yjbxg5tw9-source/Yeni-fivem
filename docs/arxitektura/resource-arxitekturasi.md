# 196RP — RESOURCE ARXİTEKTURASI və ASILIQLIQ AĞACI

> Texniki sənəd. Bütün custom resursların strukturu, məsuliyyəti və bir-birinə asılılığı.
> Framework: **Qbox (qbx_core)** + ox_lib + ox_inventory + ox_target + oxmysql.

---

## 1. Prinsiplər

1. **Modul arxitekturası** — hər sistem ayrı resource, ayrı məsuliyyət.
2. **Asılılıq ağacı sənədləşdirilir** — resource çıxarılsa, nə qırılar bilinir.
3. **Server-side validation** — bütün pul/əşya/icazə/satış əməliyyatları serverdə yoxlanılır.
4. **Prefiks** — bütün custom resurslar `vr_` (Velmora Republic) prefiksi ilə.
5. **Lokallaşdırma** — bütün UI mətnləri azərbaycanca, ayrı `locales` fayllarında.

---

## 2. Kataloq strukturu

```
resources/
├── [core]/          # Framework və kitabxanalar (mənbədən quraşdırılır)
│   ├── qbx_core/       # Qbox core
│   ├── ox_lib/         # Ümumi kitabxana (callback, menu, zone, progress…)
│   ├── ox_inventory/   # Inventar
│   ├── ox_target/      # Target (interaksiya)
│   ├── oxmysql/        # MySQL bağlayıcısı
│   ├── pma-voice/      # Mumble səs sistemi (Addım 5)
│   └── txAdmin/        # Server idarə paneli
│
├── [vr]/           # 196RP custom resurslar
│   ├── vr_core/        # Əsas paylaşılan kod (exports, konfiq, locale)
│   ├── vr_lore/        # Velmora lore konfiqi (şəhər/ad/bayram adları)
│   ├── vr_identity/    # Personaj, VRN, şəxsi profil
│   ├── vr_whitelist/   # Whitelist və vətəndaşlıq səviyyələri
│   ├── vr_admin/       # Admin alətləri + audit log
│   ├── vr_phone/       # Telefon + tətbiqlər (UI)
│   ├── vr_banking/     # Bank, kredit, debet kartı
│   ├── vr_economy/     # Vergi, büdcə, birja, dinamik qiymətlər
│   ├── vr_companies/   # Şirkətlər, işçi, maaş, müqavilə, səhm
│   ├── vr_property/    # Əmlak, kirayə, mebel, kommunal
│   ├── vr_vehicles/    # VIN, texniki baxış, sığorta, aşınma
│   ├── vr_garages/     # Qaraj, parking, impound
│   ├── vr_licenses/    # Lisenziyalar və sənədlər
│   ├── vr_police/      # Polis: MDT, sübut, ballistika, radar
│   ├── vr_ems/         # Təcili tibbi xidmət, qan bankı
│   ├── vr_fire/        # Yanğın-xilasetmə
│   ├── vr_court/       # Məhkəmə, docket, iş arxivi
│   ├── vr_government/  # Bələdiyyə, vergi-gömrük, seçki, notariat
│   ├── vr_criminal/    # Dəstələr, qara bazar, soyğun, qaçaqmalçılıq
│   ├── vr_drugs/       # Narkotik zənciri
│   ├── vr_prison/      # Həbsxana
│   ├── vr_jobs/        # Mülki işlər (taksi, fermer, mexanik…)
│   ├── vr_voice/       # Səs konfiqi (pma-voice inteqrasiyası)
│   └── vr_ui/          # HUD, statuslar, ölüm ekranı, brendinq
│
└── [stream]/       # MLO, textura, audio (böyük fayllar)
    ├── vr_mlo_government/
    ├── vr_mlo_court/
    ├── vr_mlo_hospital/
    ├── vr_mlo_police/
    ├── vr_mlo_nightclub/
    └── vr_branding/    # Velmora nişanları, lövhələr, yol nişanları
```

---

## 3. Asılılıq Ağacı (dependency tree)

Aşağıdakı ox "`A → B`" = "A, B-dən asılıdır".

```
qbx_core → oxmysql
ox_inventory → ox_lib, qbx_core
ox_target → ox_lib, qbx_core

vr_core → qbx_core, ox_lib
vr_lore → vr_core

vr_identity → vr_core, vr_lore
vr_whitelist → vr_core, vr_identity
vr_admin → vr_core, vr_identity

vr_banking → vr_core, vr_identity
vr_economy → vr_banking, vr_core
vr_companies → vr_economy, vr_banking, vr_licenses
vr_property → vr_economy, vr_banking
vr_vehicles → vr_core, vr_licenses
vr_garages → vr_vehicles, vr_core
vr_licenses → vr_identity, vr_core

vr_phone → vr_core, vr_banking, vr_economy
vr_jobs → vr_core, vr_licenses, vr_economy

vr_police → vr_core, vr_identity, vr_vehicles, vr_phone
vr_ems → vr_core, vr_identity, vr_phone
vr_fire → vr_core, vr_identity
vr_court → vr_core, vr_identity, vr_licenses
vr_government → vr_core, vr_economy, vr_companies

vr_criminal → vr_core, vr_economy, vr_vehicles, vr_police
vr_drugs → vr_criminal, vr_core
vr_prison → vr_core, vr_police, vr_court

vr_voice → pma-voice, vr_core
vr_ui → vr_core, vr_identity
```

### Qeyd
- `vr_ui` ən çox oxunan (HUD/status) resursdur; sırf oxuma üçün `vr_core`-a çıxışı var, məntiq server tərəfdədir.
- `vr_criminal` ↔ `vr_police` arasında birbaşa asılılıq yox, yalnız "qara bazar dinamikası" üçün `vr_economy` üzərindən dolayı əlaqə var (aşağıda).

---

## 4. Resurs məsuliyyət cədvəli (qısa)

| Resource | Server-side | Client-side | Məlumat bazası |
|----------|:-----------:|:-----------:|----------------|
| vr_core | ✅ əsas exports | ✅ paylaşılan | `vr_config` |
| vr_identity | ✅ VRN, profil | ✅ character creation UI | `vr_characters` |
| vr_whitelist | ✅ səviyyələr | ✅ giriş UI | `vr_whitelist` |
| vr_banking | ✅ əməliyyatlar | ✅ bank app | `vr_accounts`, `vr_transactions` |
| vr_economy | ✅ vergi/büdcə/birja | ✅ qrafiklər | `vr_budget`, `vr_stocks`, `vr_prices` |
| vr_police | ✅ MDT/sübut | ✅ MDT UI, radar | `vr_evidence`, `vr_mdt` |
| … | | | |

---

## 5. Hadisə (event) konvensiyaları

- Bütün custom NetEvents `vr:...` prefiksi ilə (məs. `vr:identity:create`).
- Server callback-ləri `vr:...:server` və ya ox_lib `lib.callback`.
- Pul/əşya dəyişdirən hər şey server-side callback; client yalnız UI təqdim edir.

---

## 6. Yüklənmə qaydası (server.cfg `ensure`)

```
ensure oxmysql
ensure qbx_core
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure vr_core
ensure vr_lore
ensure vr_identity
ensure vr_whitelist
... (asılılıq ağacına uyğun qalanları)
```

> Yükləmə qaydası asılılıq ağacına tam uyğundur; `vr_core` hamıdan əvvəl (qbx_core-dan sonra) yüklənir.
