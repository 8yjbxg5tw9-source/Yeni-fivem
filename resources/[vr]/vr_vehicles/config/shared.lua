-- ============================================================
-- vr_vehicles — Konfiq
-- ============================================================

local config = {}

-- Aşınma (condition) sürətləri
config.WearPerKm = 0.01 -- hər km-ə 0.01% aşınma

-- Texniki baxış periodu (gün)
config.InspectionPeriod = 30

-- Sığortasız sürmə cəriməsi (S₺)
config.NoInsuranceFine = 5000

-- Yanacaq növləri
config.FuelTypes = { 'gasoline', 'diesel', 'electric' }

return config