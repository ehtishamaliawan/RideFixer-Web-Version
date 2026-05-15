(function () {
  const shell = document.getElementById('endUserApp');
  if (!shell) return;

  const stateKey = 'ridefixer_end_user_state_v1';
  const fallbackState = {
    bikes: [{ id: Date.now(), name: 'My E-Bike', km: 850 }],
    reminders: [{ id: Date.now() + 1, title: 'Chain lubrication', dueKm: 1000, done: false }],
  };

  let state;
  try {
    state = JSON.parse(localStorage.getItem(stateKey) || 'null') || fallbackState;
  } catch (_err) {
    state = fallbackState;
  }

  const tabs = Array.from(document.querySelectorAll('.tab'));
  tabs.forEach((tab) => {
    tab.addEventListener('click', () => {
      tabs.forEach((x) => x.classList.remove('active'));
      tab.classList.add('active');
      document.querySelectorAll('[id^="tab-"]').forEach((panel) => panel.classList.remove('active'));
      const panel = document.getElementById('tab-' + tab.dataset.tab);
      if (panel) panel.classList.add('active');
    });
  });

  const save = () => localStorage.setItem(stateKey, JSON.stringify(state));

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/\"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function renderGarage() {
    const panel = document.getElementById('tab-garage');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <form id="bikeForm" class="item" style="display:grid;gap:8px;">
          <h3 style="margin:0">Add bike</h3>
          <label>Name</label>
          <input id="bikeName" required placeholder="Delivery bike" />
          <label>Current KM</label>
          <input id="bikeKm" type="number" value="0" min="0" />
          <button class="btn btn-brand" type="submit">Save</button>
        </form>
        <div class="item">
          <h3 style="margin:0">Garage list</h3>
          <div class="list" style="margin-top:8px;">
            ${state.bikes.map((b) => `<div class="row"><div class="row-top"><strong>${escapeHtml(b.name)}</strong><span class="badge">${Number(b.km || 0).toFixed(0)} km</span></div></div>`).join('')}
          </div>
        </div>
      </div>
    `;
    document.getElementById('bikeForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const name = document.getElementById('bikeName').value.trim();
      const km = Number(document.getElementById('bikeKm').value || 0);
      if (!name) return;
      state.bikes.push({ id: Date.now() + Math.random(), name, km });
      save();
      renderGarage();
      renderReminders();
    });
  }

  function renderReminders() {
    const panel = document.getElementById('tab-reminders');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <form id="reminderForm" class="item" style="display:grid;gap:8px;">
          <h3 style="margin:0">Add reminder</h3>
          <label>Title</label>
          <input id="reminderTitle" required placeholder="Brake check" />
          <label>Due KM</label>
          <input id="reminderKm" type="number" value="0" min="0" />
          <button class="btn btn-brand" type="submit">Save</button>
        </form>
        <div class="item">
          <h3 style="margin:0">Reminder list</h3>
          <div class="list" style="margin-top:8px;">
            ${state.reminders.map((r) => `<div class="row"><div class="row-top"><strong>${escapeHtml(r.title)}</strong><span class="badge">${Number(r.dueKm || 0).toFixed(0)} km</span></div></div>`).join('')}
          </div>
        </div>
      </div>
    `;
    document.getElementById('reminderForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const title = document.getElementById('reminderTitle').value.trim();
      const dueKm = Number(document.getElementById('reminderKm').value || 0);
      if (!title) return;
      state.reminders.push({ id: Date.now() + Math.random(), title, dueKm, done: false });
      save();
      renderReminders();
    });
  }

  function renderQuickSearch() {
    const panel = document.getElementById('tab-errors');
    if (!panel) return;
    panel.innerHTML = `
      <form id="quickErrorForm" class="item" style="display:grid;gap:8px;">
        <h3 style="margin:0">Quick error lookup</h3>
        <label>Brand</label>
        <select id="quickBrand">
          <option value="bosch">Bosch</option>
          <option value="yamaha">Yamaha</option>
          <option value="shimano">Shimano</option>
          <option value="bafang">Bafang</option>
          <option value="brose">Brose</option>
          <option value="generic">Generic</option>
        </select>
        <label>Code</label>
        <input id="quickCode" placeholder="e01" />
        <button class="btn btn-brand" type="submit">Open SEO Page</button>
      </form>
    `;
    document.getElementById('quickErrorForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const brand = document.getElementById('quickBrand').value;
      const code = (document.getElementById('quickCode').value || '').trim().toLowerCase();
      if (!code) return;
      window.location.href = '/error-codes/' + encodeURIComponent(brand) + '/' + encodeURIComponent(code);
    });
  }

  function renderShops() {
    const panel = document.getElementById('tab-shops');
    if (!panel) return;
    panel.innerHTML = `
      <div class="item" style="display:grid;gap:8px;">
        <h3 style="margin:0">Nearby shops</h3>
        <p class="sub">Find shops near your location and open directions in Maps.</p>
        <button id="shopBtn" class="btn btn-brand" type="button">Find shops near me</button>
        <div id="shopStatus" class="sub"></div>
      </div>
    `;
    document.getElementById('shopBtn').addEventListener('click', () => {
      const status = document.getElementById('shopStatus');
      if (!navigator.geolocation) {
        status.textContent = 'Geolocation not supported. Opening fallback map.';
        window.open('https://www.google.com/maps/search/bicycle+shops+near+me', '_blank', 'noopener');
        return;
      }
      status.textContent = 'Getting location...';
      navigator.geolocation.getCurrentPosition((position) => {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;
        const url = 'https://www.google.com/maps/search/bicycle+shops/@' + lat + ',' + lon + ',14z';
        status.textContent = 'Opening maps...';
        window.open(url, '_blank', 'noopener');
      }, () => {
        status.textContent = 'Permission denied. Opening fallback map.';
        window.open('https://www.google.com/maps/search/bicycle+shops+near+me', '_blank', 'noopener');
      });
    });
  }

  renderGarage();
  renderReminders();
  renderQuickSearch();
  renderShops();
})();
