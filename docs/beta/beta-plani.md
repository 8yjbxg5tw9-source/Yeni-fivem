# 196RP — QAPALI BETA PLANI (Mərhələ 4)

> Açılışdan əvvəl məcburi yoxlanış mərhələsi. Hədəf: 30–50 testçi, 1–2 həftə.
> Bütün sistemlər Addım 1–8-də qurulub; bu mərhələdə onlar CANLI yoxlanılır və balanslanır.

---

## 1. Məqsədlər

1. **Bug aşkarlama** — kodun real oyun şəraitində səhvlərinin tapılması.
2. **Balans** — iqtisadiyyat, cinayət, dövlət işləri rəqəmlərinin tənzimlənməsi.
3. **Stress-test** — 128 slot hədəfinin sınağı.
4. **Oyunçu təcrübəsi** — whitelist, RP Akademiya, ilk iş axınının yoxlanması.
5. **Təhlükəsizlik** — exploit/dupe/cheat aşkarlanması.

---

## 2. Testçi heyəti (30–50 nəfər)

| Qrup | Sayı | Vəzifəsi |
|------|------|----------|
| Veteran RP oyunçuları | 10–15 | Sistem dərinliyini yoxlayır |
| Yeni oyunçular | 10–15 | Başlanğıc təcrübəsini yoxlayır |
| Staff (Helper→Admin) | 5–8 | Moderasiya və report axını |
| Streamer/Content | 5–8 | Media, broadcast, izləyici təcrübəsi |
| Tech-testçilər | 3–5 | Performans, exploit, resmon |

> Beta testerlərə IC kosmetik mükafat verilir (sənin bölmə 31 tələbin).

---

## 3. Mərhələlər (1–2 həftə)

| Gün | Mərhələ | Fokus |
|-----|---------|-------|
| 1–2 | **Tüstü testi** (smoke test) | Server açılır? Core sistemlər işləyir? |
| 3–5 | **Funksional test** | Hər sistemin ayrıca yoxlanması (checklist-ə bax) |
| 6–8 | **Stress-test** | 128 slot, yüksək yük, server performansı |
| 9–12 | **Balans** | İqtisadiyyat/cinayət rəqəmləri, bug-fix |
| 13–14 | **Son qəbul** | Açılış hazırlığı, freeze |

---

## 4. Rollar və öhdəliklər

| Rol | Öhdəlik |
|-----|----------|
| Beta koordinatoru | Plan, cədvəl, hesabat |
| Tech-testçi | Performans, resmon, exploit |
| Balansçı | İqtisadi/cinayət rəqəmləri |
| Bug-master | Bug-ları qeydə almaq, prioritetləmək |
| Staff | Moderasiya, report, əl kitabçası yoxlanışı |

---

## 5. Bug hesabatı formatı

```
- Başlıq: (qısa təsvir)
- Şiddət: Critical / Major / Minor / Cosmetic
- Sistem: (resource adı)
- Təkrarlanma addımları:
- Gözlənilən nəticə:
- Faktiki nəticə:
- Ekran/qeyd: (klip linki)
```

## 6. Şiddət təsnifatı

| Şiddət | Tərif | Reaksiya |
|--------|-------|----------|
| Critical | Pul/əşya dupe, exploit, server crash | Dərhal freeze + hotfix |
| Major | Sistem funksiyası sıradan çıxıb | 24 saat ərzində fix |
| Minor | Qeyri-kritik səhv | Növbəti patch |
| Cosmetic | Görünüş/typo | Yığım siyahısına |

---

## 7. Qəbul meyarları (beta bitmək üçün)

- [ ] 0 açıq Critical bug
- [ ] 128 slot stress-test KEÇİLDİ (aşağıdakı sənədə bax)
- [ ] İqtisadiyyat balans cədvəli təsdiqləndi
- [ ] Bütün resurslar resmon həddində (idle < 0.05ms, aktiv < 0.35ms)
- [ ] Whitelist axını ucdan-uca yoxlanıldı
- [ ] Staff əl kitabçası praktikada sınaqdan keçdi

> *Beta hesabatı ayrıca tərtib edilir və açılış qərarına daxil edilir.*
