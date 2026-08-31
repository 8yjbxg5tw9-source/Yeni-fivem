# 196RP — TƏHLÜKƏSİZLİK TƏMƏLLƏRİ

> Secure Your Events prinsipi + anti-cheat + audit + backup. Bu sənəd bütün resurslara tətbiq olunan məcburi standartdır.

---

## 1. Server-side Validation (Secure Your Events)

**Prinsip:** Client heç vaxt etibarlı mənbə deyil. Bütün kritik əməliyyatlar serverdə yoxlanılır.

Hər pul/əşya/icazə/satış/koordinat/inventar əməliyyatında server:
1. Oyunçunun mövcud olduğunu yoxlayır.
2. Oyunçunun icazəsinin olduğunu yoxlayır (iş, lisenziya, səviyyə).
3. Məbləğin/miqdarın məntiqi olduğunu yoxlayır (mənfi, həddən artıq).
4. Əməliyyatı audit log-a yazır.

```lua
-- NÜMUNƏ (vr_banking): pul köçürmə
lib.callback.register('vr:banking:transfer', function(source, target, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or amount > 1000000 then return false end  -- limit
    if not exports.vr_banking:hasEnough(source, amount) then return false end
    -- əməliyyat + audit log
    exports.vr_admin:audit('bank_transfer', source, target, amount)
    return true
end)
```

**Qadağan:** client-in birbaşa `TriggerServerEvent` ilə öz balansını artırması. Hər şey server-side callback ilə.

---

## 2. Anti-Cheat və Server-side Qoruma

- **Server-side hesablama** — məsafə, damage, inventory, pul.
- **Şübhəli teleport/sürət** aşkarlanması (anti-speedhack, anti-teleport).
- **Resurs integrity** — fayl hash-ləri vaxtaşırı yoxlanılır (fayl bütövlük nəzarəti).
- **Injection/exploit** aşkarlanması: qeyri-adi event axını, spam, qeyri-mövcud item istifadəsi.
- **DDoS müdafiəsi** — server səviyyəsində (hosting/CF), tətbiq səviyyəsində rate-limit.
- **2FA** — txAdmin panel girişində məcburi.

---

## 3. Audit Log Sistemi (`vr_admin`)

Bütün admin əməliyyatları və kritik server əməliyyatları avtomatik loglanır:

| Hadisə | Loglanan məlumat |
|--------|------------------|
| Admin pul/əşya verdi | admin, hədəf, məbləğ/əşya, səbəb, zaman |
| Ban/kick/warn | staff, oyunçu, səbəb, müddət |
| Teleport/spectate/noclip | staff, hədəf, koordinat |
| Pul köçürmə (böyük) | göndərən, alan, məbləğ |
| İnventar əməliyyatı | oyunçu, əşya, miqdar, mənbə |
| Qara bazar satışı | satıcı, alıcı, əşya, qiymət |

Loglar Discord `#audit-log` kanalına və `vr_audit_log` cədvəlinə yazılır. **İctimai audit** prinsipi: icma üzvləri pul/əşya yaradılmasını görə bilir.

---

## 4. İqtisadi Anomaliya Detektoru

- Kəskin pul axını (ani böyük balans artımı) → flag.
- Qısa müddətdə çoxlu əməliyyat → flag.
- Dupe şübhəsi (eyni serial №-li əşya iki yerdə) → flag.
- Flag-lar staff-a bildirilir və araşdırılır.

---

## 5. Backup və DR (Fəlakət Bərpası)

| Element | Dəyər |
|---------|-------|
| Backup tezliyi | Gündəlik avtomatik (tam DB dump) |
| Backup saxlanma | 7 gün (həftəlik 4 həftə) |
| Restore testi | Ayda 1 dəfə məşq edilir |
| RPO | 24 saat |
| RTO | 2 saat |

**Prosedur:**
1. `mysqldump` gündəlik cron ilə.
2. Dump-lar ayrı diskə/obyekt yaddaşına kopyalanır.
3. Aylıq restore məşqi: test serverində bərpa edilir və yoxlanılır.

---

## 6. Discord Audit Log

- Bütün staff əməliyyatları Discord `#audit-log`-a yazılır.
- Loglar silinə bilməz (yalnız Founder oxu/saxlama səlahiyyəti).

---

## 7. Exploit-İstifadəçi Araşdırma Proseduru

1. Detektor flag verir → staff-a bildiriş.
2. Araşdırma: loglar, əməliyyat tarixçəsi, cihaz/fingerprint.
3. Sübut varsa → cəza (qaydalar + cəza pilləsi).
4. Cihaz+fingerprint əsaslı ban-müqavimət analitikası (alt hesabla geri dönmənin qarşısı).

---

## 8. Fayl Bütövlük Nəzarəti

- Kritik resource fayllarının hash-i saxlanır.
- Dəyişiklik aşkarlanarsa → admin bildirişi.
- İcazəsiz dəyişiklik = təhlükəsizlik insidenti kimi araşdırılır.

---

> *Bu standartlar hər resursun code-review-ində yoxlanılır; live-a çıxan resource bu tələblərə cavab verməlidir.*
