// ============================================================
// 196RP — Kadr botu (staff müraciəti və növbə)
// ============================================================

import { EmbedBuilder } from 'discord.js'
import { query } from './db.js'

export async function handleStaff(message, args) {
  const sub = args[0]?.toLowerCase()

  if (sub === 'müraciət' || sub === 'muraciet') {
    const embed = new EmbedBuilder()
      .setTitle('196RP — Staff Müraciəti')
      .setColor(0xD9A441)
      .setDescription(
        'Staff könüllü və maaşsızdır (IC-yə müdaxiləsiz).\n\n' +
        '**Proses:**\n1. Form doldurma\n2. Müsahibə\n3. 2 həftə sınaq\n\n' +
        'Səviyyələr: Helper → Moderator → Admin → Senior Admin → Head Admin → Founder'
      )
    await message.channel.send({ embeds: [embed] })
    return
  }

  if (sub === 'status') {
    const member = await message.guild.members.fetch(message.author.id)
    const staffRole = process.env.ROLE_STAFF
    if (!member.roles.cache.has(staffRole)) {
      await message.reply('Status yoxlama yalnız staff üçündür.')
      return
    }
    const rows = await query('SELECT rank, probation FROM vr_staff WHERE discord_id = ?', [message.author.id])
    if (!rows.length) {
      await message.reply('Staff qeydiniz tapılmadı.')
      return
    }
    const r = rows[0]
    await message.reply(`**Rütbə:** ${r.rank} | **Sınaqda:** ${r.probation ? 'Bəli' : 'Xeyr'}`)
    return
  }

  await message.reply('İstifadə: `!kadr müraciət` | `!kadr status`')
}
