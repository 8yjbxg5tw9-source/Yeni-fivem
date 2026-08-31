# 196RP — FƏLAKƏT BƏRPASI (DR) PLANI

> RPO: 24 saat · RTO: 2 saat (sənin bölmə 34 tələbin).
> Hədəf: istənilən nasazlıqda serveri 2 saat ərzində bərpa etmək, maksimum 24 saatlıq məlumat itkisi.

---

## 1. Əsas göstəricilər

| Metrik | Dəyər | Məna |
|--------|-------|------|
| RPO (Recovery Point Objective) | 24 saat | Ən pis halda 24 saatlıq məlumat itkisi |
| RTO (Recovery Time Objective) | 2 saat | Bərpa üçün maksimum vaxt |
| Backup tezliyi | Gündəlik | Tam DB dump |
| Backup saxlanma | 7 gün + həftəlik 4 həftə | Rotasiya |

---

## 2. Backup proseduru

1. **Gündəlik** (avtomatik, cron):
   ```
   mysqldump -u user -p 196rp > /backups/196rp-$(date +%F).sql
   ```
2. Dump-lar **ayrı diskə / obyekt yaddaşına** kopyalanır.
3. Hash yoxlanışı (dump bütövlüyü).
4. 7 gündən köhnə gündəliklər silinir; həftəliklər 4 həftə saxlanılır.

---

## 3. Restore proseduru (RTO 2 saat)

| Addım | Vaxt | Əməliyyat |
|-------|------|-----------|
| 1 | 0–15 dəq | İnsident aşkarlanması + elan (Discord status) |
| 2 | 15–30 dəq | Son etibarlı backup seçimi |
| 3 | 30–60 dəq | DB bərpası (restore) |
| 4 | 60–90 dəq | Server restart + yoxlama (smoke test) |
| 5 | 90–120 dəq | Canlıya qaytarma + elan |

---

## 4. İnsident növləri və cavab

| İnsident | Cavab |
|----------|-------|
| DB korlanması | Restore (yuxarıdakı prosedur) |
| Server crash | Restart + log analizi |
| Hücum/DDoS | Təhlükəsizlik təbəqəsi + host provayder |
| Əhəmiyyətli exploit | Serveri dayandır + patch + restore |

---

## 5. Aylıq Restore Məşqi (məcburi)

Hər ay test serverində:
1. Son backup götürülür.
2. Test serverinə restore edilir.
3. Bütövlük yoxlanılır (cədvəllər, oyunçu məlumatları).
4. Nəticə qeydə alınır (keçdi/uğursuz).

> **Məşq edilməmiş bərpa planı = etibarsız plandır.** Bu, sənin bölmə 27 tələbin.

---

## 6. Əlaqə və eskalasiya

| Rol | Məsuliyyət |
|-----|-----------|
| Developer | Texniki bərpa |
| Head Admin | İcma elanı, koordinasiya |
| Founder | Son qərar |

**Eskalasiya:** Developer → Head Admin → Founder (30 dəqiqədə cavab yoxdursa yuxarı).

---

## 7. DR Test Qeydi

| Tarix | Test növü | Nəticə | RTO faktiki | RPO faktiki |
|-------|-----------|--------|-------------|-------------|
| | Restore məşqi | | | |
| | Restore məşqi | | | |

> *Bu cədvəl hər aylıq məşqdən sonra doldurulur.*
