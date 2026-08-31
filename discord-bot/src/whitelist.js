// ============================================================
// 196RP — Whitelist botu (9 mərhələli müraciət axını)
// ============================================================

import { EmbedBuilder } from 'discord.js'
import { query } from './db.js'

// RP termini testi (Mərhələ 4)
const RP_QUESTIONS = [
  'NVL (No Value of Life) nədir?',
  'FearRP nədir?',
  'Metagaming (MG) nədir? Bir nümunə verin.',
  'Powergaming (PG) nədir?',
  'NLR (New Life Rule) nədir?',
  'Combat Logging nədir və niyə qadağandır?',
]

export async function handleWhitelist(message, args) {
  const sub = args[0]?.toLowerCase()

  if (sub === 'müraciət' || sub === 'muraciet') {
    const embed = new EmbedBuilder()
      .setTitle('196RP — Whitelist Müraciəti')
      .setColor(0x0E4B6E)
      .setDescription(
        'Velmora Respublikasına müraciət 9 mərhələdən ibarətdir:\n' +
        '1. Discord təsdiqi\n2. Qaydalar\n3. Whitelist forması\n4. RP termini testi\n' +
        '5. Personaj hekayəsi\n6. Səsli müsahibə\n7. Müvəqqəti vətəndaşlıq\n' +
        '8. 7–14 gün sınaq\n9. Tam vətəndaşlıq\n\n' +
        'Formanı doldurmaq üçün `#whitelist-murac` kanalına keçin.'
      )
    await message.channel.send({ embeds: [embed] })
    return
  }

  if (sub === 'status') {
    // Staff icazəsi yoxlaması
    const member = await message.guild.members.fetch(message.author.id)
    const staffRole = process.env.ROLE_STAFF
    if (!member.roles.cache.has(staffRole)) {
      await message.reply('Status yoxlama yalnız staff üçündür.')
      return
    }
    const target = message.mentions.users.first()
    if (!target) {
      await message.reply('İstifadəni qeyd edin: `!whitelist status @istifadəçi`')
      return
    }
    const rows = await query(
      'SELECT level, trial_until, mentor_id FROM vr_citizenship WHERE citizenid = ?',
      [target.id]
    )
    if (!rows.length) {
      await message.reply('Bu istifadəçi whitelist-də yoxdur.')
      return
    }
    const r = rows[0]
    await message.reply(`**${target.username}** — Səviyyə: ${r.level}, Sınaq sonu: ${r.trial_until ?? '—'}`)
    return
  }

  if (sub === 'test') {
    await message.reply(
      '**RP Termini Testi** (whitelist formasında tam cavablandırılır):\n' + RP_QUESTIONS.map((q, i) => `${i + 1}. ${q}`).join('\n')
    )
    return
  }

  await message.reply('İstifadə: `!whitelist müraciət` | `!whitelist test` | `!whitelist status @istifadəçi`')
}
