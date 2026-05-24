(function () {
  const shell = document.getElementById('endUserApp');
  if (!shell) return;

  const stateKey = 'ridefixer_end_user_state_v2';
  const fallbackState = {
    bikes: [{ id: Date.now(), name: 'My E-Bike', brand: 'Generic / Chinese Controller', display: 'SW900 / S866 style', km: 850 }],
    batteries: [{ id: Date.now() + 1, bike: 'My E-Bike', voltage: 48, ah: 13, cycles: 120, health: 86 }],
    reminders: [{ id: Date.now() + 2, title: 'Chain lubrication', dueKm: 1000, done: false }],
    diagnostics: [{ id: Date.now() + 3, title: 'Generic E07 Hall Sensor Fault', url: '/error-codes/generic/e07', date: new Date().toISOString().slice(0, 10) }],
    notes: 'Example: Check brake pads, spoke tension and controller connectors every few weeks.',
  };

  let state;
  try {
    state = JSON.parse(localStorage.getItem(stateKey) || 'null') || fallbackState;
  } catch (_err) {
    state = fallbackState;
  }

  state.bikes = state.bikes || fallbackState.bikes;
  state.batteries = state.batteries || fallbackState.batteries;
  state.reminders = state.reminders || fallbackState.reminders;
  state.diagnostics = state.diagnostics || fallbackState.diagnostics;
  state.notes = state.notes || '';

  const save = () => localStorage.setItem(stateKey, JSON.stringify(state));

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
        <form id="bikeForm" class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Add bike</h3>
          <label>Name</label>
          <input id="bikeName" required placeholder="Delivery bike, Carrera, Fiido, Engwe..." />
          <label>System / Brand</label>
          <select id="bikeBrand">
            <option>Generic / Chinese Controller</option>
            <option>Bafang</option>
            <option>Bosch</option>
            <option>Shimano STEPS</option>
            <option>Yamaha</option>
            <option>Brose</option>
          </select>
          <label>Display / Controller</label>
          <input id="bikeDisplay" placeholder="SW900, S866, KT-LCD3, Bafang DPC..." />
          <label>Current KM</label>
          <input id="bikeKm" type="number" value="0" min="0" />
          <button class="btn btn-brand" type="submit">Save Bike</button>
        </form>
        <div class="item">
          <h3 style="margin:0">Garage list</h3>
          <div class="list" style="margin-top:10px;">
            ${state.bikes.map((b) => `<div class="row"><div class="row-top"><strong>${escapeHtml(b.name)}</strong><span class="badge">${Number(b.km || 0).toFixed(0)} km</span></div><p class="sub">${escapeHtml(b.brand || 'Unknown system')} · ${escapeHtml(b.display || 'Display not set')}</p></div>`).join('')}
          </div>
        </div>
      </div>
    `;
    document.getElementById('bikeForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const name = document.getElementById('bikeName').value.trim();
      const brand = document.getElementById('bikeBrand').value;
      const display = document.getElementById('bikeDisplay').value.trim();
      const km = Number(document.getElementById('bikeKm').value || 0);
      if (!name) return;
      state.bikes.push({ id: Date.now() + Math.random(), name, brand, display, km });
      save();
      renderAll();
    });
  }

  function renderBattery() {
    const panel = document.getElementById('tab-battery');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <form id="batteryForm" class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Battery profile</h3>
          <label>Bike</label>
          <input id="batteryBike" placeholder="My E-Bike" value="${escapeHtml(state.bikes[0]?.name || '')}" />
          <label>Voltage</label>
          <select id="batteryVoltage"><option>36</option><option selected>48</option><option>52</option><option>60</option><option>72</option></select>
          <label>Capacity Ah</label>
          <input id="batteryAh" type="number" min="1" step="0.1" value="13" />
          <label>Estimated cycles</label>
          <input id="batteryCycles" type="number" min="0" value="0" />
          <button class="btn btn-brand" type="submit">Save Battery</button>
          <a class="btn btn-dark" href="/battery-health-calculator">Open full calculator</a>
        </form>
        <div class="item">
          <h3 style="margin:0">Saved batteries</h3>
          <div class="list" style="margin-top:10px;">
            ${state.batteries.map((b) => `<div class="row"><div class="row-top"><strong>${escapeHtml(b.bike)}</strong><span class="badge low">${Number(b.health || 100)}% health</span></div><p class="sub">${Number(b.voltage)}V · ${Number(b.ah)}Ah · ${Number(b.cycles || 0)} cycles</p></div>`).join('')}
          </div>
        </div>
      </div>
    `;
    document.getElementById('batteryForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const bike = document.getElementById('batteryBike').value.trim() || 'My E-Bike';
      const voltage = Number(document.getElementById('batteryVoltage').value);
      const ah = Number(document.getElementById('batteryAh').value || 0);
      const cycles = Number(document.getElementById('batteryCycles').value || 0);
      const health = Math.max(45, Math.min(100, Math.round(100 - cycles * 0.06)));
      state.batteries.push({ id: Date.now() + Math.random(), bike, voltage, ah, cycles, health });
      save();
      renderBattery();
    });
  }

  function renderReminders() {
    const panel = document.getElementById('tab-reminders');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <form id="reminderForm" class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Add maintenance reminder</h3>
          <label>Task</label>
          <input id="reminderTitle" required placeholder="Brake check, tyre pressure, chain lubrication..." />
          <label>Due KM</label>
          <input id="reminderKm" type="number" value="0" min="0" />
          <button class="btn btn-brand" type="submit">Save Reminder</button>
        </form>
        <div class="item">
          <h3 style="margin:0">Reminder list</h3>
          <div class="list" style="margin-top:10px;">
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

  function renderDiagnostics() {
    const panel = document.getElementById('tab-diagnostics');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <div class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Diagnostic shortcuts</h3>
          <a class="btn btn-brand" href="/scan">Scan display error</a>
          <a class="btn btn-dark" href="/motor-noise-diagnostic">Motor sound diagnostic</a>
          <a class="btn btn-dark" href="/settings/generic">Chinese display P-settings</a>
          <a class="btn btn-dark" href="/error-codes/generic/e07">Hall sensor fault guide</a>
        </div>
        <div class="item">
          <h3 style="margin:0">Saved diagnostic history</h3>
          <div class="list" style="margin-top:10px;">
            ${state.diagnostics.map((d) => `<a class="row" href="${escapeHtml(d.url)}"><div class="row-top"><strong>${escapeHtml(d.title)}</strong><span class="badge">${escapeHtml(d.date)}</span></div></a>`).join('')}
          </div>
        </div>
      </div>
    `;
  }

  function renderQuickSearch() {
    const panel = document.getElementById('tab-errors');
    if (!panel) return;
    panel.innerHTML = `
      <form id="quickErrorForm" class="item" style="display:grid;gap:10px;">
        <h3 style="margin:0">Quick error lookup</h3>
        <label>Brand</label>
        <select id="quickBrand">
          <option value="generic">Generic / Chinese Controller</option>
          <option value="bafang">Bafang</option>
          <option value="bosch">Bosch</option>
          <option value="yamaha">Yamaha</option>
          <option value="shimano">Shimano</option>
          <option value="brose">Brose</option>
        </select>
        <label>Code</label>
        <input id="quickCode" placeholder="e07, e29, 21, 503..." />
        <button class="btn btn-brand" type="submit">Open SEO Page</button>
      </form>
    `;
    document.getElementById('quickErrorForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const brand = document.getElementById('quickBrand').value;
      const code = (document.getElementById('quickCode').value || '').trim().toLowerCase();
      if (!code) return;
      const title = brand + ' ' + code.toUpperCase();
      const url = '/error-codes/' + encodeURIComponent(brand) + '/' + encodeURIComponent(code);
      state.diagnostics.unshift({ id: Date.now() + Math.random(), title, url, date: new Date().toISOString().slice(0, 10) });
      save();
      window.location.href = url;
    });
  }

  function renderShops() {
    const panel = document.getElementById('tab-shops');
    if (!panel) return;
    panel.innerHTML = `
      <div class="item" style="display:grid;gap:10px;">
        <h3 style="margin:0">Nearby shops</h3>
        <p class="sub">Find bike and e-bike repair shops near your location and open directions in Maps.</p>
        <button id="shopBtn" class="btn btn-brand" type="button">Find shops near me</button>
        <a class="btn btn-dark" href="https://www.google.com/maps/search/e-bike+repair+near+me" target="_blank" rel="noopener">Open fallback map</a>
        <div id="shopStatus" class="sub"></div>
      </div>
    `;
    document.getElementById('shopBtn').addEventListener('click', () => {
      const status = document.getElementById('shopStatus');
      if (!navigator.geolocation) {
        status.textContent = 'Geolocation not supported. Opening fallback map.';
        window.open('https://www.google.com/maps/search/e-bike+repair+near+me', '_blank', 'noopener');
        return;
      }
      status.textContent = 'Getting location...';
      navigator.geolocation.getCurrentPosition((position) => {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;
        const url = 'https://www.google.com/maps/search/e-bike+repair/@' + lat + ',' + lon + ',14z';
        status.textContent = 'Opening maps...';
        window.open(url, '_blank', 'noopener');
      }, () => {
        status.textContent = 'Permission denied. Opening fallback map.';
        window.open('https://www.google.com/maps/search/e-bike+repair+near+me', '_blank', 'noopener');
      });
    });
  }

  function renderData() {
    const panel = document.getElementById('tab-data');
    if (!panel) return;
    panel.innerHTML = `
      <div class="split">
        <div class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Garage notes</h3>
          <textarea id="garageNotes" placeholder="Write repair notes, controller model, battery age, service history...">${escapeHtml(state.notes)}</textarea>
          <button id="saveNotes" class="btn btn-brand" type="button">Save Notes</button>
        </div>
        <div class="item" style="display:grid;gap:10px;">
          <h3 style="margin:0">Data controls</h3>
          <p class="sub">Data is stored locally in this browser. Future version can sync this with login.</p>
          <button id="exportData" class="btn btn-dark" type="button">Export JSON</button>
          <button id="resetData" class="btn btn-dark" type="button">Reset Local Garage</button>
          <pre id="dataOutput" style="white-space:pre-wrap;overflow:auto;max-height:260px;"></pre>
        </div>
      </div>
    `;
    document.getElementById('saveNotes').addEventListener('click', () => {
      state.notes = document.getElementById('garageNotes').value;
      save();
    });
    document.getElementById('exportData').addEventListener('click', () => {
      document.getElementById('dataOutput').textContent = JSON.stringify(state, null, 2);
    });
    document.getElementById('resetData').addEventListener('click', () => {
      if (!confirm('Reset RideFixer local garage data?')) return;
      localStorage.removeItem(stateKey);
      window.location.reload();
    });
  }

  function renderAll() {
    renderGarage();
    renderBattery();
    renderReminders();
    renderDiagnostics();
    renderQuickSearch();
    renderShops();
    renderData();
  }

  renderAll();
})();
