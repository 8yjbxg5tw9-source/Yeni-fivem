// ============================================================
// 196RP — Discord Bot (əsas)
// Whitelist bot + Log bot + Kadr bot + Statistika bot
// ============================================================

import { Client, GatewayIntentBits, EmbedBuilder } from 'discord.js'
import 'dotenv/config'
import { query } from './db.js'
import { handleWhitelist } from './whitelist.js'
import { handleStaff } from './staff.js'
import { handleStats } from './stats.js'

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.GuildMembers,
  ],
})

client.once('ready', () => {
  console.log(`[196RP] Bot hazırdır: ${client.user.tag}`)
})

// === Komanda idarəedilməsi ===
client.on('messageCreate', async (message) => {
  if (message.author.bot) return

  // Sadə prefiks komandaları (slash commands ilə əvəz edilə bilər)
  const args = message.content.trim().split(/\s+/)
  const cmd = args.shift()?.toLowerCase()

  try {
    switch (cmd) {
      case '!whitelist':
        await handleWhitelist(message, args)
        break
      case '!kadr':
        await handleStaff(message, args)
        break
      case '!statistika':
        await handleStats(message)
        break
      case '!komek':
        await message.reply(
          '**196RP — Komandalar**\n' +
          '`!whitelist müraciət` — forma keçidi\n' +
          '`!whitelist status @istifadəçi` — status yoxla (staff)\n' +
          '`!kadr müraciət` — staff müraciəti\n' +
          '`!statistika` — server statistikası'
        )
        break
    }
  } catch (err) {
    console.error('[196RP] Komanda xətası:', err)
    message.reply('Xəta baş verdi. Administrator ilə əlaqə saxlayın.')
  }
})

client.login(process.env.DISCORD_TOKEN)
