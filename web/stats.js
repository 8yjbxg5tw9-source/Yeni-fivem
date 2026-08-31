// ============================================================
// 196RP — Veb səhifə: canlı statistika
// Real istehsalda server API-ə (backend) bağlanır.
// ============================================================

const API_URL = '/api/stats' // backend endpoint

async function loadStats() {
  try {
    const res = await fetch(API_URL)
    const data = await res.json()

    document.getElementById('stat-online').textContent = data.online ?? '—'
    document.getElementById('stat-crime').textContent = data.crime_index ?? '—'
    document.getElementById('stat-tax').textContent = `S₺ ${data.tax_revenue ?? '—'}`
    document.getElementById('stat-citizens').textContent = data.citizens ?? '—'
  } catch (err) {
    // API yoxdursa, yer tutucu saxlanır
    console.log('[196RP] Statistika API-i tapılmadı (nümayiş rejimi)')
  }
}

// 30 saniyədə bir yenilə
loadStats()
setInterval(loadStats, 30000)
