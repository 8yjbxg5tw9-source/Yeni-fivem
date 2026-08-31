# 196RP — TEST CHECKLIST (Hər sistemin yoxlanışı)

> Beta zamanı hər bənd işarələnir. Bütün resurslar bu siyahı ilə yoxlanılır.
> Format: [ ] = yoxlanılmadı, [x] = keçdi, [!] = bug var (bug hesabatına).

---

## 1. Core və Identiklik
- [ ] Server açılır, qbx_core yüklənir
- [ ] vr_core exportları işləyir
- [ ] VRN yaradılır (format VR-#########, checksum düzgün)
- [ ] Personaj yaradılır (character creation)
- [ ] Barber / tatu işləyir
- [ ] Plastik cərrahiyyə: ödəniş + cooldown
- [ ] Vətəndaşlıq Reyestri: nikah/boşanma/ölüm/vəsiyyət

## 2. Whitelist və Vətəndaşlıq
- [ ] Giriş yoxlaması (whitelist-siz giriş rədd)
- [ ] Səviyyələr (temporary→citizen→trusted→veteran)
- [ ] Sınaq müddəti (14 gün) yoxlanması
- [ ] Mentor təyini

## 3. Admin və Audit
- [ ] warn/kick/ban/teleport işləyir
- [ ] givemoney yalnız head+ icazəsi
- [ ] Audit log DB + Discord yazılır
- [ ] İctimai audit callback

## 4. Bank və İqtisadiyyat
- [ ] Hesab yaratma (VL + nömrə)
- [ ] Köçürmə (limit, mənfi yoxlama)
- [ ] Depozit/çıxarış
- [ ] Əmanət faizi
- [ ] Büdcə: vergi → xəzinə → maaş
- [ ] Birja: al/sat, qiymət dalğalanması
- [ ] Dinamik qiymətlər + inflyasiya log

## 5. Şirkətlər və Peşələr
- [ ] Şirkət yaratma (lisenziya tələbi)
- [ ] İşçi götürmə, maaş
- [ ] Stok idarəetməsi
- [ ] Peşə zənciri kilidi (restoran↔fermer)
- [ ] Səhm satışı + reyestr

## 6. Əmlak və Nəqliyyat
- [ ] Əmlak alqı-satqı
- [ ] İpoteka (ilkin + qalan)
- [ ] Kirayə
- [ ] Kommunal faktura + kəsmə
- [ ] VIN + tarixçə
- [ ] Sığorta, aşınma, texniki baxış

## 7. Səs və Telefon
- [ ] pıçıltı/normal/qışqırıq məsafələri
- [ ] Radio + headset tələbi
- [ ] Şifrəli tezliklər (polis/EMS)
- [ ] Avtomobil səs filtri
- [ ] Telefon: SMS, kontakt, Kvatter, xəbər, bank
- [ ] Bütün tətbiqlər açılır (16 tətbiq)

## 8. Status və UI
- [ ] Statuslar (aclıq/susuzluq/stress/yorğunluq)
- [ ] Vizual siqnallar
- [ ] Emote paketi
- [ ] Əlçatanlıq (rəngkor, böyük şrift)
- [ ] Ölüm ekranı + NLR mesajı

## 9. Polis
- [ ] MDT: şəxs/VIN axtarışı
- [ ] Axtarış qərarı (mexaniki kilid)
- [ ] BOLO, insident, cərimə
- [ ] Sübut: barmaq izi/DNT/giliz/qan
- [ ] Breathalyzer, narkotest, radar
- [ ] Impound, panik düyməsi

## 10. EMS və Yanğın
- [ ] Yara növləri + prosedurlar
- [ ] Qan bankı + donor + transfuziya
- [ ] Asılılıq/reabilitasiya
- [ ] Reanimasiya pəncərəsi
- [ ] Yanğın yayılma, qaz sızması

## 11. Məhkəmə və Hökumət
- [ ] İş açma, docket
- [ ] 3 instansiya apellyasiya
- [ ] Münsiflər, transkript
- [ ] Vergi, gömrük, seçki
- [ ] Notariat müqavilə + icra qüvvəsi

## 12. Kriminal
- [ ] Dəstə + turf + reputasiya
- [ ] Soyğun pilləsi (9 pillə, reputasiya kilidi)
- [ ] Minigame-lər (lockpick/hack/termit)
- [ ] Qara bazar (dinamik qiymət/risk)
- [ ] Narkotik zənciri (5 mərhələ)
- [ ] Pul yuma + saxta invoys
- [ ] Qaçaqmalçılıq (gömrük yoxlaması)
- [ ] Həbsxana: iş, parole, bail, konvoy

## 13. Təhlükəsizlik
- [ ] Secure Your Events (server-side validation)
- [ ] Dupe/exploit cəhdləri (tech-testçi)
- [ ] İqtisadi anomaliya detektoru
- [ ] Ban-fingerprint

## 14. Yeni Oyunçu Təcrübəsi
- [ ] Whitelist axını ucdan-uca
- [ ] İlk iş (taksi/kuryer)
- [ ] Bələdçi tətbiqi
- [ ] Mentor köməyi

---

> *Bu checklist beta koordinatoru tərəfindən doldurulur və həftəlik hesabatda yekunlaşdırılır.*
