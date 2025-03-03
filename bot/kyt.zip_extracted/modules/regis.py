from kyt import *

# // DELETE IP
@bot.on(events.CallbackQuery(data=b'deleteip'))
async def deleteipp(event):
    async def deleteipp_(event):
        async with bot.conversation(chat) as pw:
            await event.respond("**Input IP VPS yang akan dihapus:**")
            pw = pw.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            pw = (await pw).raw_text
        cmd = f'printf "%s\n" "{pw}" | del-ip-bot'
        try:
            a = subprocess.check_output(cmd, shell=True).decode("utf-8")
        except:
            await event.respond("**IP tidak ditemukan atau terjadi kesalahan**")
        else:
            msg = f"""
**━━━━━━━━━━━━━━━━━━━**
 **⟨ SUKSES HAPUS IP ADDRESS ⟩**
**━━━━━━━━━━━━━━━━━━━**
 `IP VPS   :` `{pw}`
**━━━━━━━━━━━━━━━━━━━**
**» 🤖@fernandairfan**"""
            await event.respond(msg)
    chat = event.chat_id
    sender = await event.get_sender()
    a = valid(str(sender.id))
    if a == "true":
        await deleteipp_(event)
    else:
        await event.answer("Akses Ditolak", alert=True)

# // ADD IP
@bot.on(events.CallbackQuery(data=b'resgissc'))
async def registersc(event):
    async def registersc_(event):
        async with bot.conversation(chat) as user:
            await event.respond('**Username:**')
            user = user.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            user = (await user).raw_text
        async with bot.conversation(chat) as pw:
            await event.respond("**IP VPS:**")
            pw = pw.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            pw = (await pw).raw_text
        async with bot.conversation(chat) as exp:
            await event.respond("**Pilih Masa Aktif**", buttons=[
                [Button.inline(" 30 Hari ", "30"),
                 Button.inline(" 60 Hari ", "60")],
                [Button.inline(" 90 Hari ", "90"),
                 Button.inline(" Lifetime ", "360")]
            ])
            exp = exp.wait_event(events.CallbackQuery)
            exp = (await exp).data.decode("ascii")
        cmd = f'printf "%s\n" "{pw}" "{user}" "{exp}" | add-ip-bot'
        try:
            a = subprocess.check_output(cmd, shell=True).decode("utf-8")
        except:
            await event.respond("**Terjadi kesalahan saat menambahkan IP**")
        else:
            msg = f"""
`🧿───────────────────🧿`
**REGISTRASI AUTOSCRIPT PREMIUM**
`🧿───────────────────🧿`
` ID   : ``{user}`
` IP   : ``{pw}`
` Masa Aktif : ``{exp} Hari`
`🧿───────────────────🧿`
**Notifikasi otomatis dari GitHub**
`🧿───────────────────🧿`
** Klik untuk membuat tautan instalasi **
https://pastebin.com/raw/hiW6LEjy
"""
            await event.respond(msg)
    chat = event.chat_id
    sender = await event.get_sender()
    a = valid(str(sender.id))
    if a == "true":
        await registersc_(event)
    else:
        await event.answer("Akses Ditolak", alert=True)

# // RENEW IP
@bot.on(events.CallbackQuery(data=b'renewip'))
async def renewip(event):
    async def renewip_(event):
        async with bot.conversation(chat) as pw:
            await event.respond("**Input IP VPS yang akan diperbarui:**")
            pw = pw.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            pw = (await pw).raw_text
        async with bot.conversation(chat) as exp:
            await event.respond("**Pilih Masa Aktif Baru**", buttons=[
                [Button.inline(" 30 Hari ", "30"),
                 Button.inline(" 60 Hari ", "60")],
                [Button.inline(" 90 Hari ", "90"),
                 Button.inline(" Lifetime ", "360")]
            ])
            exp = exp.wait_event(events.CallbackQuery)
            exp = (await exp).data.decode("ascii")
        cmd = f'printf "%s\n" "{pw}" "{exp}" | renew-ip-bot'
        try:
            a = subprocess.check_output(cmd, shell=True).decode("utf-8")
        except:
            await event.respond("**IP tidak ditemukan atau terjadi kesalahan**")
        else:
            msg = f"""
**━━━━━━━━━━━━━━━━━━━**
 **⟨ SUKSES RENEW IP ADDRESS ⟩**
**━━━━━━━━━━━━━━━━━━━**
 `IP VPS   :` `{pw}`
 `Masa Aktif Baru :` `{exp} Hari`
**━━━━━━━━━━━━━━━━━━━**
**» 🤖@fernandairfan**"""
            await event.respond(msg)
    chat = event.chat_id
    sender = await event.get_sender()
    a = valid(str(sender.id))
    if a == "true":
        await renewip_(event)
    else:
        await event.answer("Akses Ditolak", alert=True)

# // CHANGE IP
@bot.on(events.CallbackQuery(data=b'changeip'))
async def changeip(event):
    async def changeip_(event):
        async with bot.conversation(chat) as old_ip:
            await event.respond("**Input IP VPS lama yang akan diganti:**")
            old_ip = old_ip.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            old_ip = (await old_ip).raw_text
        async with bot.conversation(chat) as new_ip:
            await event.respond("**Input IP VPS baru:**")
            new_ip = new_ip.wait_event(events.NewMessage(incoming=True, from_users=sender.id))
            new_ip = (await new_ip).raw_text
        cmd = f'printf "%s\n" "{old_ip}" "{new_ip}" | change-ip-bot'
        try:
            a = subprocess.check_output(cmd, shell=True).decode("utf-8")
        except:
            await event.respond("**IP lama tidak ditemukan atau terjadi kesalahan**")
        else:
            msg = f"""
**━━━━━━━━━━━━━━━━━━━**
 **⟨ SUKSES CHANGE IP ADDRESS ⟩**
**━━━━━━━━━━━━━━━━━━━**
 `IP Lama   :` `{old_ip}`
 `IP Baru   :` `{new_ip}`
**━━━━━━━━━━━━━━━━━━━**
**» 🤖@fernandairfan**"""
            await event.respond(msg)
    chat = event.chat_id
    sender = await event.get_sender()
    a = valid(str(sender.id))
    if a == "true":
        await changeip_(event)
    else:
        await event.answer("Akses Ditolak", alert=True)

# // MENU UTAMA
@bot.on(events.CallbackQuery(data=b'regis'))
async def menu(event):
    inline = [
        [Button.inline(" TAMBAH IP ", "resgissc"),
         Button.inline(" HAPUS IP ", "deleteip")],
        [Button.inline(" RENEW IP ", "renewip"),
         Button.inline(" CHANGE IP ", "changeip")],
        [Button.url(" JOIN ", "https://t.me/fernandairfan")],
        [Button.inline("‹ KEMBALI ›", "menu")]
    ]
    sender = await event.get_sender()
    val = valid(str(sender.id))
    if val == "false":
        try:
            await event.answer("Akses Ditolak", alert=True)
        except:
            await event.reply("Akses Ditolak")
    elif val == "true":
        sh = f' curl -sS https://raw.githubusercontent.com/jvoscript/permission/main/ip | grep "###" | wc -l'
        usersc = subprocess.check_output(sh, shell=True).decode("ascii")
        sdss = f" cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/PRETTY_NAME//g'"
        namaos = subprocess.check_output(sdss, shell=True).decode("ascii")
        ipvps = f" curl -s ipv4.icanhazip.com"
        ipsaya = subprocess.check_output(ipvps, shell=True).decode("ascii")

        msg = f"""
🧿───────────────────🧿
   **REGISTRASI IP AUTO SCRIPT**
🧿───────────────────🧿
Halo {sender.first_name}
`Total Online  :` `{usersc.strip()}`
`Autoscript By :` @fernandairfan
🧿───────────────────🧿

"""
        x = await event.edit(msg, buttons=inline)
        if not x:
            await event.reply(msg, buttons=inline)