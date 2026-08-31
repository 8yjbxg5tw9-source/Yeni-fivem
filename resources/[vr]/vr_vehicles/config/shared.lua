-- ============================================================
-- vr_vehicles — Konfiq
-- ============================================================

vr = vr or {}
vr.Vehicles = {}

-- Aşınma (condition) sürətləri
vr.Vehicles.WearPerKm = 0.01 -- hər km-ə 0.01% aşınma

-- Texniki baxış periodu (gün)
vr.Vehicles.InspectionPeriod = 30

-- Sığortasız sürmə cəriməsi (S₺)
vr.Vehicles.NoInsuranceFine = 5000

-- Yanacaq növləri
vr.Vehicles.FuelTypes = { 'gasoline', 'diesel', 'electric' }

return vr
