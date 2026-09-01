return {
    serverName = 'Server',
    defaultSpawn = vec4(-540.58, -212.02, 37.65, 208.88),
    notifyPosition = 'top-right', -- 'top' | 'top-right' | 'top-left' | 'bottom' | 'bottom-right' | 'bottom-left'
    ---@type { name: string, amount: integer, metadata: fun(source: number): table }[]
    starterItems = { -- Character starting items
        { name = 'phone', amount = 1 },
        -- qeyd: şəxsiyyət (VRN) və lisenziyalar DB əsaslıdır (vr_identity / vr_licenses),
        -- ox_inventory item-i deyil — qbx_idcard tələb olunmur.
    }
}
