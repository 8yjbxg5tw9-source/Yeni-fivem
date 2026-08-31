-- ============================================================
-- vr_banking — Client: bank app açılışı və notify
-- (Tam UI "vr_phone" içində bank tətbiqi kimi Addım 5-də gəlir)
-- ============================================================

-- Bank balansını oxumaq (UI üçün)
exports('getBalance', function()
    return lib.callback.await('vr:banking:getBalance', false)
end)

-- Köçürmə (UI üçün)
exports('transfer', function(target, amount, note)
    return lib.callback.await('vr:banking:transfer', false, target, amount, note)
end)
