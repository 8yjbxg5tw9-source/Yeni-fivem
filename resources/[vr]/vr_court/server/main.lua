-- ============================================================
-- vr_court — Server: iş açma, docket, instansiyalar, münsiflər
-- ============================================================

-- === İş aç (vəkil/prokuror/hakim) ===
lib.callback.register('vr:court:openCase', function(source, caseType, plaintiff, defendant)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    local allowed = { judge = true, prosecutor = true, lawyer = true }
    if not allowed[job] then return false, 'Yalnız məhkəmə rolları iş aça bilər' end

    local caseNo = ('CASE-%s'):format(math.random(100000, 999999))
    MySQL.insert.await(
        'INSERT INTO vr_court_cases (case_no, type, instance, plaintiff, defendant) VALUES (?, ?, ?, ?, ?)',
        { caseNo, caseType, 'lower', plaintiff, defendant }
    )
    return true, caseNo
end)

-- === Docket (iclas cədvəli) ===
lib.callback.register('vr:court:getDocket', function(source)
    return MySQL.query.await("SELECT * FROM vr_court_cases WHERE status IN ('pending','hearing') ORDER BY created_at DESC")
end)

-- === Hakim təyini ===
lib.callback.register('vr:court:assignJudge', function(source, caseId, judgeId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'judge' then return false end
    MySQL.update.await('UPDATE vr_court_cases SET judge = ? WHERE id = ?', { judgeId, caseId })
    return true
end)

-- === Münsiflər heyəti (jury) ===
lib.callback.register('vr:court:enableJury', function(source, caseId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'judge' then return false end
    MySQL.update.await('UPDATE vr_court_cases SET jury = 1 WHERE id = ?', { caseId })
    return true
end)

-- === Qərar (verdict) ===
lib.callback.register('vr:court:verdict', function(source, caseId, verdict)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'judge' then return false end
    MySQL.update.await('UPDATE vr_court_cases SET status = ?, verdict = ? WHERE id = ?', { 'decided', verdict, caseId })
    return true
end)

-- === Apellyasiya (növbəti instansiyaya) ===
lib.callback.register('vr:court:appeal', function(source, caseId, grounds)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    local allowed = { judge = true, lawyer = true, prosecutor = true }
    if not allowed[job] then return false end

    local case = MySQL.single.await('SELECT * FROM vr_court_cases WHERE id = ?', { caseId })
    if not case then return false end

    local nextInstance
    if case.instance == 'lower' then nextInstance = 'appeal'
    elseif case.instance == 'appeal' then nextInstance = 'supreme'
    else return false, 'Ali Məhkəmədən yuxarı instansiya yoxdur' end

    MySQL.update.await('UPDATE vr_court_cases SET instance = ?, status = ?, transcript = ? WHERE id = ?',
        { nextInstance, 'pending', grounds, caseId })
    return true, nextInstance
end)

-- === Transkript yüklə ===
lib.callback.register('vr:court:getTranscript', function(source, caseId)
    local case = MySQL.single.await('SELECT case_no, transcript, verdict FROM vr_court_cases WHERE id = ?', { caseId })
    return case
end)

-- === Vəkillik kollegiya imtahanı (lisenziya) ===
lib.callback.register('vr:court:barExam', function(source, answers)
    local player = qbx.getPlayer(source)
    if not player then return false end
    -- Sadə qiymətləndirmə: cavabların ən azı 70%-i düzgün olmalıdır
    -- (real suallar ayrıca konfiqdə; burada nümunə)
    local correct = 0
    local total = #(answers or {})
    for _, a in ipairs(answers or {}) do
        if a == true then correct = correct + 1 end
    end
    if total > 0 and (correct / total) >= 0.7 then
        -- Vəkil lisenziyası ver
        exports.vr_licenses:giveLicense(source, 'professional', nil)
        return true, 'Vəkillik imtahanından keçdiniz'
    end
    return false, 'İmtahan keçilmədi'
end)

print('[vr_court] Məhkəmə sistemi aktivdir.')
