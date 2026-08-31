// ============================================================
// 196RP — Telefon UI (azərbaycanca)
// ============================================================

const APPS = [
    { id: 'phone', label: 'Telefon', icon: 'fa-phone' },
    { id: 'messages', label: 'Mesajlar', icon: 'fa-comment' },
    { id: 'contacts', label: 'Kontaktlar', icon: 'fa-address-book' },
    { id: 'camera', label: 'Kamera', icon: 'fa-camera' },
    { id: 'gallery', label: 'Qalereya', icon: 'fa-images' },
    { id: 'notes', label: 'Notlar', icon: 'fa-sticky-note' },
    { id: 'kvatter', label: 'Kvatter', icon: 'fa-feather' },
    { id: 'darkweb', label: 'Qaranlıq Şəbəkə', icon: 'fa-user-secret' },
    { id: 'taxi', label: 'Taksi', icon: 'fa-taxi' },
    { id: 'race', label: 'Yeraltı Yarış', icon: 'fa-flag-checkered' },
    { id: 'government', label: 'Dövlət', icon: 'fa-landmark' },
    { id: 'jobs', label: 'İş Axtarışı', icon: 'fa-briefcase' },
    { id: 'bank', label: 'Bank', icon: 'fa-university' },
    { id: 'news', label: 'Xəbərlər', icon: 'fa-newspaper' },
    { id: 'weather', label: 'Hava', icon: 'fa-cloud-sun' },
    { id: 'guide', label: 'Bələdçi', icon: 'fa-compass' },
];

function post(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        body: JSON.stringify(data || {}),
        headers: { 'Content-Type': 'application/json' }
    }).then(r => r.json());
}

// Saat
setInterval(() => {
    const d = new Date();
    document.getElementById('clock').textContent =
        `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
}, 1000);

// App grid qur
const grid = document.getElementById('appGrid');
APPS.forEach(app => {
    const el = document.createElement('div');
    el.className = 'app';
    el.innerHTML = `<i class="fa-solid ${app.icon}"></i><span>${app.label}</span>`;
    el.addEventListener('click', () => openApp(app.id));
    grid.appendChild(el);
});

function openApp(id) {
    const home = document.getElementById('home');
    home.classList.add('hidden');
    const screen = document.getElementById(`${id}-screen`);
    if (screen) screen.classList.remove('hidden');
    if (id === 'messages') loadMessages();
    if (id === 'contacts') loadContacts();
    if (id === 'kvatter') loadKvatter();
    if (id === 'news') loadNews();
    if (id === 'bank') loadBalance();
}

// Geri düymələri
document.querySelectorAll('.back').forEach(btn => {
    btn.addEventListener('click', () => {
        const screen = btn.getAttribute('data-screen');
        document.querySelectorAll('.screen').forEach(s => s.classList.add('hidden'));
        document.getElementById(screen).classList.remove('hidden');
    });
});

// === Mesajlar ===
async function loadMessages() {
    const msgs = await post('getMessages');
    const list = document.getElementById('messagesList');
    list.innerHTML = '';
    (msgs || []).forEach(m => {
        const el = document.createElement('div');
        el.className = 'list-item';
        el.innerHTML = `<b>${m.from}</b><p>${m.body}</p><div class="meta">${m.created_at}</div>`;
        list.appendChild(el);
    });
}
document.getElementById('sendMsgBtn').addEventListener('click', async () => {
    const to = document.getElementById('msgTo').value;
    const body = document.getElementById('msgBody').value;
    if (!to || !body) return;
    await post('sendMessage', { to, body });
    document.getElementById('msgBody').value = '';
    loadMessages();
});

// === Kontaktlar ===
async function loadContacts() {
    const contacts = await post('getContacts');
    const list = document.getElementById('contactsList');
    list.innerHTML = '';
    (contacts || []).forEach(c => {
        const el = document.createElement('div');
        el.className = 'list-item';
        el.innerHTML = `<b>${c.name}</b><p>${c.number}</p>`;
        list.appendChild(el);
    });
}
document.getElementById('addContactBtn').addEventListener('click', async () => {
    const name = document.getElementById('contactName').value;
    const number = document.getElementById('contactNumber').value;
    if (!name || !number) return;
    await post('addContact', { name, number });
    loadContacts();
});

// === Kvatter ===
document.getElementById('postKvatterBtn').addEventListener('click', async () => {
    const body = document.getElementById('kvatterBody').value;
    if (!body) return;
    await post('postKvatter', { body });
    document.getElementById('kvatterBody').value = '';
    loadKvatter();
});
async function loadKvatter() {
    const posts = await post('getKvatter');
    const feed = document.getElementById('kvatterFeed');
    feed.innerHTML = '';
    (posts || []).forEach(p => {
        const el = document.createElement('div');
        el.className = 'list-item';
        el.innerHTML = `<b>@${p.author}</b><p>${p.body}</p><div class="meta">❤️ ${p.likes}</div>`;
        feed.appendChild(el);
    });
}

// === Xəbərlər ===
async function loadNews() {
    const news = await post('getNews');
    const list = document.getElementById('newsList');
    list.innerHTML = '';
    (news || []).forEach(n => {
        const el = document.createElement('div');
        el.className = 'list-item';
        el.innerHTML = `<b>${n.title}</b><p>${n.body}</p><div class="meta">${n.outlet}</div>`;
        list.appendChild(el);
    });
}

// === Bank ===
async function loadBalance() {
    const balance = await post('getBalance');
    document.getElementById('bankBalance').textContent = `S₺ ${balance ?? 0}`;
}

// NUI mesajları (açılış/bağlanma)
window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'setVisible') {
        document.getElementById('phone').classList.toggle('hidden', !data.visible);
    }
});

// Bağlanma (ESC)
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') post('close');
});
