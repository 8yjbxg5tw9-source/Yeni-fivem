# 196RP — 128 SLOT STRESS-TEST PROSEDURU (MƏCBURİ)

> Açılışdan əvvəl həftəlik 128 slot stress-test məcburidir.
> Hədəf: 128 oyunçu, sabit FPS, resmon həddində, crash yox.

---

## 1. Hazırlıq

- [ ] Ayrı test serveri (istehsaldan ayrı)
- [ ] 128 slot aktiv (sv_maxclients 128)
- [ ] Profiler/resmon aktiv
- [ ] Loglar aktiv (server + client + DB)
- [ ] Yük generatoru / bot oyunçular (və ya real testçi qrupu)

---

## 2. Test ssenariləri

| Ssenari | Təsvir | Hədəf |
|---------|--------|-------|
| **S1 — Boş server** | 0 oyunçu, idle | idle < 0.05ms/resource |
| **S2 — Dolu server** | 128 oyunçu online | aktiv < 0.35ms/resource |
| **S3 — Pik yük** | 128 oyunçu + eyni anda əməliyyatlar | crash yox, sabit cavab |
| **S4 — Mərkəz** | Hamı Asterra mərkəzində | server tərəfi FPS sabit |
| **S5 — Çoxsaylı nəqliyyat** | 128 maşın eyni anda | OneSync performansı |
| **S6 — Səs yükü** | Hamı danışır (Mumble) | səs gecikməsi yox |
| **S7 — Inventar/DB** | 128 oyunçu eyni anda DB yazır | DB ölü nöqtə yox |

---

## 3. Metrikalar (həddlər)

| Metrik | Hədd | Ölçmə |
|--------|------|-------|
| Server FPS | ≥ 50 | txAdmin/status |
| Client FPS (mərkəzdə) | ≥ 40 | testçi ölçümü |
| Resource idle | < 0.05 ms | resmon |
| Resource aktiv | < 0.35 ms | resmon |
| DB cavab müddəti | < 100 ms | oxmysql log |
| Crash | 0 | server log |
| Səs gecikməsi | < 200 ms | Mumble |

---

## 4. İcra qaydası

1. S1 → bazal ölçü (boş server).
2. Oyunçuları tədricən artır (25 → 50 → 75 → 100 → 128).
3. Hər səviyyədə metrikaları qeyd et.
4. S3–S7 ssenarilərini 128-də icra et.
5. Nəticələri cədvələ yaz (aşağıda).

---

## 5. Nəticə cədvəli

| Slot | Server FPS | Aktiv ms (ən pis resource) | Crash? | Nəticə |
|------|-----------|----------------------------|--------|--------|
| 25 | | | | |
| 50 | | | | |
| 75 | | | | |
| 100 | | | | |
| 128 | | | | |

---

## 6. Həddi aşan resource proseduru

Resmon-da həddi aşan resource:
1. Profiler ilə səbəb tapılır (hansı thread/event).
2. Optimizasiya: client-server bölgüsü, loop tezliyi, event azaldılması.
3. Yenidən stress-test.
4. **Aşan resource canlıya çıxmır** (məcburi qayda).

---

## 7. Stress-test keçid meyarları

- [ ] 128 slotda server FPS ≥ 50
- [ ] 0 crash
- [ ] Bütün resurslar hədd daxilində
- [ ] DB cavab < 100 ms
- [ ] Səs gecikməsi < 200 ms

> *Uğursuz test = açılış təxirə salınır. Bu, sənin bölmə 28 tələbindir və qəti qaydadır.*
