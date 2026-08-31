# 196RP — Resources

## Struktur

```
resources/
├── [core]/      # Framework və kitabxanalar (mənbədən klonlanır, bu repoda deyil)
│   ├── qbx_core/
│   ├── ox_lib/
│   ├── ox_inventory/
│   ├── ox_target/
│   ├── oxmysql/
│   ├── qbx_skin/
│   ├── pma-voice/
│   └── txAdmin/
│
└── [vr]/        # 196RP custom resursları (bu repoda)
    ├── vr_core/        # Əsas kod + konfiq + locale (az)
    ├── vr_lore/        # Velmora lore konfiqi
    ├── vr_identity/    # Personaj, VRN, barber/tatu/plastik cərrahiyyə, reyestr
    ├── vr_whitelist/   # Whitelist girişi + vətəndaşlıq səviyyələri
    ├── vr_admin/       # Admin alətləri + audit log
    ├── vr_banking/     # Bank, köçürmə, faiz
    ├── vr_licenses/    # Lisenziyalar (xallı cərimə)
    └── vr_items/       # Əşya metadata (keyfiyyət, seriya, mülkiyyət, durability)
```

## Quraşdırma

1. `[core]` resurslarını rəsmi mənbələrdən klonlayın (Qbox, overwolf/ox_lib, ox_inventory, ox_target, oxmysql, qbx_skin, pma-voice, txAdmin).
2. `server.cfg`-də `CHANGEME_` dəyərlərini real açar/şifrələrlə əvəz edin (git-ə getməsin).
3. `sql/` fayllarını sıra ilə icra edin (`00` → `08`).
4. `ensure` qaydası `server.cfg`-də hazırdır.

## Lokallaşdırma

Bütün UI mətnləri Azərbaycan dilindədir. Əsas locale `vr_core/locales/az.lua`-dədir; hər resurs öz mətnlərini oradan və ya öz `config`-indən çəkir.
