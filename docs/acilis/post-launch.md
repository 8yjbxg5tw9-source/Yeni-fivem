# 196RP — POST-LAUNCH ƏMƏLİYYAT PLANI

> Açılışdan sonrakı davamlı əməliyyat. Sabitlik və böyümə üçün.

---

## 1. Patch Cədvəli

| Element | Dəyər |
|---------|-------|
| Tezlik | 2 həftədə 1 patch |
| Changelog | Discord `#patch-changelog` |
| Hotfix | Critical bug üçün dərhal (qeyri-cədvəl) |
| Beta test | Hər böyük yeniləmə əvvəl test serverində |

**Patch dövrü:**
```
İnkişaf (7 gün) → Test (4 gün) → Balans (2 gün) → Canlı (1 gün)
```

---

## 2. Aylıq Balans İclası

- **İştirak:** Developer + Balansçı + Head Admin + (lazım gələrsə) icma nümayəndəsi.
- **Məzmun:** İqtisadiyyat/cinayət rəqəmləri, inflyasiya, anomaliya hesabatı.
- **Nəticə:** Balans cədvəlinin yenilənməsi + changelog + icma elanı.

---

## 3. İcma Rəy Dövrü

- Discord `#icma-rey` daimi açıq.
- Feedback → prioritet lövhəsi (roadmap board) — `docs/beta/feedback-roadmap.md`.
- Aylıq hesabat: nə təsdiqləndi, nə icra edildi.

---

## 4. Mövsüm Dövrü

| Faz | Müddət | Hadisə |
|-----|--------|--------|
| Açılış | 1 həftə | IC mərasim, media |
| İnkişaf | 8–10 həftə | Lore Komandası canlı süjetlər |
| Kulminasiya | 1–2 həftə | Mövsüm finalı hadisəsi |
| Keçid | 1 həftə | İqtisadi soft-reset + hekayə dönüşü |

---

## 5. Həftəlik Radio Xəbər Buraxılışı

- Lore Komandası həftəlik səsyazma hazırlayır.
- IC dünyanın xəbərləri (seçki, vergi, fövqəladə hallar).
- Oyunçu qəzetləri ilə sinxron.

---

## 6. Davamlı Təhlükəsizlik

- Gündəlik DB backup (avtomatik).
- Aylıq restore məşqi (DR testi).
- Audit log daimi izləmə.
- Ekonomik anomaliya detektoru aktiv.

---

## 7. Böyümə planı (128 → 256)

- 128 slotda sabit işlədikdən sonra.
- Yeni stress-test (256 hədəf).
- Donanım təkmilləşdirməsi (CPU/RAM) qiymətləndirməsi.
- Mərhələli artım: 128 → 160 → 200 → 256.

> *Böyümə yalnız performans həddləri keçildikdən sonra.*
