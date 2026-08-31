// ============================================================
// 196RP — DB bağlantısı (mysql2)
// ============================================================

import mysql from 'mysql2/promise'
import 'dotenv/config'

let pool

export function getPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      waitForConnections: true,
      connectionLimit: 10,
      charset: 'utf8mb4',
    })
  }
  return pool
}

export async function query(sql, params = []) {
  const p = getPool()
  const [rows] = await p.execute(sql, params)
  return rows
}
