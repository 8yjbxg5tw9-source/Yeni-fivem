// ============================================================
// 196RP — Statistika botu (oyun-statistikası)
// ============================================================

import { EmbedBuilder } from 'discord.js'
import { query } from './db.js'

export async function handleStats(message) {
  try {
    const [citizenship] = await query('SELECT COUNT(*) as total FROM vr_citizenship')
    const [companies] = await query('SELECT COUNT(*) as total FROM vr_companies WHERE status = ?', ['active'])
    const [stocks] = await query('SELECT COUNT(*) as total FROM vr_stocks')
    const [treasury] = await query('SELECT COALESCE(SUM(amount),0) as total FROM vr_treasury')

    const embed = new EmbedBuilder()
      .setTitle('196RP — Server Statistikası')
      .setColor(0x0E4B6E)
      .addFields(
        { name: 'Vətəndaşlar', value: String(citizenship?.total ?? 0), inline: true },
        { name: 'Şirkətlər', value: String(companies?.total ?? 0), inline: true },
        { name: 'Birja səhmləri', value: String(stocks?.total ?? 0), inline: true },
        { name: 'Xəzinə balansı', value: `S₺ ${treasury?.total ?? 0}`, inline: true }
      )
      .setTimestamp()

    await message.channel.send({ embeds: [embed] })
  } catch (err) {
    console.error('[196RP] Statistik xətası:', err)
    await message.reply('Statistika alına bilmədi.')
  }
}
