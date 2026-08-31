# 196RP — Development Yol Xəritəsi

10 addım. Hər addımın sonunda sifarişçi təsdiqi olmadan növbəti addıma keçilmir.

---

## Addım 1 — Lore və Qanunvericilik (Mərhələ 0) ✅ tamamlandı
**Məqsəd:** "Kod əvvəl olmur." Oyun dünyasının hüquqi-mədəni bünövrəsi.

- [x] Velmora tarixi (ölkənin yaranması, qurucu hadisələr)
- [x] Lore pack: dövlət möhürü, bayraq, himn, valyuta (S₺), VRN, nömrə dizaynı, telefon prefiksləri, milli təqvim
- [x] Konstitusiya
- [x] Cinayət Məcəlləsi (struktur + əsas maddələr + cəza miqyası)
- [x] Mülki Məcəllə (struktur + əsas maddələr)

## Addım 2 — Qaydalar, Whitelist, Discord və Staff (Mərhələ 0–1) ✅ tamamlandı
- [x] Server qaydaları: NVL, FearRP, RDM/VDM, MG, PG, FailRP, NLR, Combat Logging, torture/həssas RP OOC razılığı
- [x] Cəza pilləsi + intizam arxivi + apellyasiya + Ombudsman
- [x] 9 mərhələli whitelist forması (situasiyalı suallar, RP termini testi, personaj hekayəsi, müsahibə)
- [x] Vətəndaşlıq səviyyələri (Müvəqqəti → Vətəndaş → Etibarlı → Veteran) + mentor sistemi
- [x] Discord struktur sxemi + botlar (whitelist, log, kadr, statistik)
- [x] Staff iyerarxiyası, səlahiyyət matrisi, əl kitabçası, eskalasiya matrisi

## Addım 3 — Texniki arxitektura və DB (Mərhələ 1) ✅ tamamlandı
- [x] Resource arxitekturası + asılılıq ağacı sənədi
- [x] MariaDB schema (personaj, inventar, bank, lisenziyalar, sübutlar, şirkətlər, vergi, əmlak…)
- [x] Repo quruluşu, `server.cfg`, konvoy/dağıtım planı
- [x] Təhlükəsizlik təməlləri (server-side validation, audit log, backup/DR planı)

## Addım 4 — Təməl Server (Mərhələ 1) ✅ tamamlandı
- [x] Qbox + ox_lib + ox_inventory + ox_target + oxmysql quraşdırması (konfiq və yükləmə qaydası)
- [x] Lokallaşdırma (100% az)
- [x] Personaj sistemi (character creation, barber, tatu, plastik cərrahiyyə)
- [x] Inventar (çəki əsaslı, metadata, durability), bank, qaraj
- [x] Whitelist + admin alətləri (ban/kick/warn/spectate/noclip + audit log)

## Addım 5 — Səs, Telefon və Statuslar (Mərhələ 1) ✅ tamamlandı
- [x] Mumble (pma-voice): pıçıltı/normal/qışqırıq, radio stansiyaları, şifrəli tezliklər, avtomobil səs filtri, headset tələbi
- [x] Telefon: zəng/SMS/kontakt/kamera/qalereya/notlar + Kvatter (Twatter analoqu), dark web, taksi, yeraltı yarış, dövlət, iş axtarışı, bank, xəbər, hava, bələdçi tətbiqləri
- [x] Statuslar: aclıq, susuzluq, stress, yorğunluq
- [x] Emote/animasiya paketi + re-bindable keybinds + rəngkor/böyük şrift rejimi

## Addım 6 — Dövlət İşləri (Mərhələ 2) ✅ tamamlandı
- [x] Polis: MDT, BOLO, sübut (barmaq izi, DNT, ballistika, bodycam), breathalyzer, narkotest, radar, impound, K9, undercover, hava vahidi
- [x] EMS: yara növləri, qan qrupları, qan bankı, asılılıq/reabilitasiya, reanimasiya pəncərəsi
- [x] Yanğın-Xilasetmə: yayılma mexanikası, qaz sızması, qəza-xilasetmə
- [x] Məhkəmə: hakim, prokuror, vəkil, münsiflər, docket; 3 instansiya
- [x] Bələdiyyə, Vergi-Gömrük, Nəqliyyat, Notariat, Reyestrlər, Seçki Komissiyası

## Addım 7 — İqtisadiyyat (Mərhələ 2) ✅ tamamlandı
- [x] Şirkətlər: işçi, maaş, müqavilə, stok, vergi, reklam, filial, səhm
- [x] Dövlət büdcəsi (vergi → xəzinə → maaş fondu), dinamik qiymətlər, inflyasiya monitorinqi
- [x] Velmora Birjası, bank dərinliyi (faiz, kredit, borc, debet kartı)
- [x] Əmlak bazarı (kriminal səviyyəyə bağlı), sığorta, lotereya
- [x] Peşə zəncirləri (restoran↔fermer, mexanik↔liman) + attestasiyalar

## Addım 8 — Kriminal Dünya (Mərhələ 3) ✅ tamamlandı
- [x] Soyğun pilləsi (market → … → Mərkəzi Bank → kazino → ada), hazırlıq RP-si, lockpick/hack/termit
- [x] Narkotik zənciri, silah emalı, qara bazar (dinamik), avto oğurluq (chop/boosting/VIN), saxta sənəd/valyuta
- [x] Liman qaçaqmalçılığı (gömrük sinxron), pul yuma, sığorta saxtakarlığı
- [x] Dəstələr: grafitti/turf, iyerarxiya, anbar; "hot items" mexanikası
- [x] Həbsxana həyatı: içəri iqtisadiyyat, parole, bail, konvoy

## Addım 9 — Beta (Mərhələ 4) ✅ tamamlandı
- [x] Qapalı beta (30–50 testçi, 1–2 həftə), balans
- [x] 128 slot stress-test (məcburi), profiler/resmon audit
- [x] Bug-fix dövrü, feedback → prioritet lövhəsi

## Addım 10 — Açılış və Post-launch (Mərhələ 5) ✅ tamamlandı
- [x] Season 1: IC açılış hadisəsi, media kampaniyası, streamer dəvətləri
- [x] Patch cədvəli (2 həftə), changelog, aylıq balans iclası
- [x] DR planı (RPO 24 saat, RTO 2 saat)
- [x] Təhvil: server dump + quraşdırma təlimatı + video bələdçi + oyunçu bələdçisi (az)
- [x] 45–60 gün texniki dəstək

---

## Prioritetlər (sıra ilə)
1. **Dil** — 100% azərbaycanca
2. **Ölkə** — 100% xəyali (real ölkə ilə sıfır əlaqə)
3. **Stabillik və optimizasiya**
4. **İqtisadi dərinlik** (büdcə–birja–vergi dövranı)
5. **Sistem dolğunluğu** (NoPixel + Prodigy + Türk Hard RP səviyyəsi)
