<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>RideFixer Shop - E-Bike Parts Coming Soon</title>
<meta name="description" content="RideFixer Shop is launching soon for e-bike parts, displays, controllers, batteries, motors and repair-first replacement guidance." />
<link rel="canonical" href="https://shop.ridefixer.app/" />
<link rel="icon" href="https://ridefixer.app/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" type="image/png" />
<link rel="apple-touch-icon" href="https://ridefixer.app/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" />
<meta name="theme-color" content="#06101d" />

<script>
try {
  const saved = localStorage.getItem("ridefixer-shop-theme");
  const prefers = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  document.documentElement.setAttribute("data-theme", saved || prefers);
} catch (e) {
  document.documentElement.setAttribute("data-theme", "dark");
}
</script>

<style>
:root {
  --bg: #06101d;
  --bg2: #081827;
  --card: rgba(255,255,255,.08);
  --card2: rgba(255,255,255,.12);
  --text: #f8fbff;
  --muted: #a9b8ca;
  --line: rgba(255,255,255,.14);
  --brand: #00d4ff;
  --green: #22c7a9;
  --ghost: rgba(255,255,255,.08);
  --shadow: 0 24px 70px rgba(0,0,0,.35);
}

html[data-theme="light"] {
  --bg: #f7fbff;
  --bg2: #edf4fa;
  --card: #ffffff;
  --card2: #ffffff;
  --text: #0b1724;
  --muted: #334155;
  --line: rgba(8,24,39,.14);
  --ghost: rgba(8,24,39,.05);
  --shadow: 0 18px 45px rgba(8,24,39,.10);
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: Inter, Manrope, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  color: var(--text);
  min-height: 100vh;
  background:
    radial-gradient(circle at 10% 0%, rgba(0,212,255,.20), transparent 28%),
    radial-gradient(circle at 90% 10%, rgba(34,199,169,.16), transparent 28%),
    linear-gradient(180deg, var(--bg), var(--bg2) 55%, var(--bg));
}

a { color: inherit; text-decoration: none; }

.wrap {
  width: min(1120px, 92vw);
  margin: 0 auto;
}

.nav {
  min-height: 78px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  flex-wrap: wrap;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 900;
  font-size: 1.22rem;
}

.brand img {
  width: 44px;
  height: 44px;
  border-radius: 14px;
  box-shadow: 0 18px 48px rgba(0,212,255,.25);
}

.links {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-wrap: wrap;
}

.links a {
  color: var(--muted);
  font-weight: 750;
}

.pill {
  padding: 10px 15px;
  border-radius: 999px;
  border: 1px solid var(--line);
  background: var(--ghost);
  color: var(--text);
  font-weight: 800;
  cursor: pointer;
}

.hero {
  padding: 42px 0 22px;
  display: grid;
  grid-template-columns: 1.1fr .9fr;
  gap: 18px;
}

.card {
  background: linear-gradient(145deg, var(--card2), var(--card));
  border: 1px solid var(--line);
  border-radius: 30px;
  box-shadow: var(--shadow);
  padding: 30px;
}

.eyebrow {
  display: inline-flex;
  padding: 8px 12px;
  border-radius: 999px;
  border: 1px solid rgba(0,150,190,.30);
  background: rgba(0,212,255,.10);
  color: #0aa6c8;
  font-size: .82rem;
  font-weight: 850;
}

html[data-theme="dark"] .eyebrow {
  color: #b7f4ff;
}

h1, h2, h3 {
  margin: 0;
  color: var(--text);
  letter-spacing: -.6px;
}

h1 {
  font-size: clamp(2.35rem, 6vw, 5rem);
  line-height: .95;
  margin-top: 16px;
}

.gradient {
  background: linear-gradient(135deg, var(--brand), #ffffff, var(--green));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

html[data-theme="light"] .gradient {
  background: linear-gradient(135deg, #0369a1, #0f172a, #0f766e);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.sub {
  color: var(--muted);
  line-height: 1.7;
}

.actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 22px;
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 13px 18px;
  border-radius: 999px;
  font-weight: 900;
}

.btn-primary {
  background: linear-gradient(135deg, var(--brand), var(--green));
  color: #00131a;
}

.btn-ghost {
  background: var(--ghost);
  border: 1px solid var(--line);
  color: var(--text);
}

.visual {
  display: grid;
  place-items: center;
  text-align: center;
  min-height: 360px;
}

.bike {
  font-size: 6.5rem;
}

.section {
  margin-top: 18px;
}

.grid, .mini {
  display: grid;
  gap: 14px;
  margin-top: 16px;
}

.grid {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.mini {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.item, .mini div {
  padding: 20px;
  border-radius: 24px;
  background: var(--ghost);
  border: 1px solid var(--line);
  color: var(--text);
}

.icon {
  font-size: 2rem;
  margin-bottom: 10px;
}

.notice {
  text-align: center;
  background: linear-gradient(135deg, rgba(34,199,169,.13), rgba(0,212,255,.08));
}

.footer {
  padding: 30px 0 42px;
  color: var(--muted);
  display: flex;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.footer a {
  color: inherit;
}

@media (max-width: 860px) {
  .hero, .grid, .mini {
    grid-template-columns: 1fr;
  }

  .nav {
    align-items: flex-start;
    padding: 14px 0;
  }

  .card {
    padding: 22px;
  }

  .actions .btn {
    width: 100%;
  }

  .bike {
    font-size: 5.5rem;
  }
}
</style>
</head>

<body>
<nav class="wrap nav">
  <a class="brand" href="https://shop.ridefixer.app/">
    <img src="https://ridefixer.app/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" alt="RideFixer" />
    <span>RideFixer Shop</span>
  </a>

  <div class="links">
    <a href="#categories">Categories</a>
    <a href="#request">Request Part</a>
    <a class="pill" href="https://ridefixer.app/">Diagnostics</a>
    <button id="themeToggle" class="pill" type="button">🌙</button>
  </div>
</nav>

<main class="wrap">
  <section class="hero">
    <article class="card">
      <span class="eyebrow">E-Bike Parts Marketplace • Launching Soon</span>
      <h1>Repair-first <span class="gradient">e-bike parts</span> for real riders.</h1>
      <p class="sub">
        RideFixer Shop is being built around diagnostics, compatibility and repair workflows for common e-bike systems.
      </p>
      <div class="actions">
        <a class="btn btn-primary" href="mailto:ridefixer232@gmail.com?subject=RideFixer%20Shop%20Part%20Request">Request a Part</a>
        <a class="btn btn-ghost" href="https://ridefixer.app/error-codes">Diagnose First</a>
      </div>
    </article>

    <aside class="card visual">
      <div>
        <div class="bike">🛒</div>
        <h2>Store v1 is coming</h2>
        <p class="sub">Focused on practical replacement parts and real rider demand.</p>
      </div>
    </aside>
  </section>

  <section id="categories" class="card section">
    <span class="eyebrow">Planned Categories</span>
    <h2 style="margin-top:12px;">Built around real repair needs.</h2>
    <div class="grid">
      <div class="item"><div class="icon">🔋</div><h3>Batteries</h3><p class="sub">Battery replacement and range related parts.</p></div>
      <div class="item"><div class="icon">🖥️</div><h3>Displays</h3><p class="sub">SW900, S866, KT LCD and common e-bike displays.</p></div>
      <div class="item"><div class="icon">⚙️</div><h3>Controllers</h3><p class="sub">Controller replacements linked to communication faults.</p></div>
      <div class="item"><div class="icon">🎛️</div><h3>Throttles</h3><p class="sub">Throttle faults, wiring issues and common replacements.</p></div>
      <div class="item"><div class="icon">🛞</div><h3>Motors & Wheels</h3><p class="sub">Hub motor and wheel replacement direction.</p></div>
      <div class="item"><div class="icon">🛠️</div><h3>Repair Essentials</h3><p class="sub">Brake parts, cables, sensors and accessories.</p></div>
    </div>
  </section>

  <section id="request" class="card section notice">
    <span class="eyebrow">Help us build the catalogue</span>
    <h2 style="margin-top:12px;">Need an e-bike part?</h2>
    <p class="sub">
      Send us the display model, error code, bike photo or part name. RideFixer Shop will prioritise real rider demand first.
    </p>
    <div class="actions" style="justify-content:center;">
      <a class="btn btn-primary" href="mailto:ridefixer232@gmail.com?subject=RideFixer%20Shop%20Part%20Request">Request by Email</a>
    </div>
  </section>

  <section class="card section">
    <h2>Compatibility focus</h2>
    <div class="mini">
      <div><strong>SW900</strong><p class="sub">Display ecosystem</p></div>
      <div><strong>S866</strong><p class="sub">Controller and display support</p></div>
      <div><strong>KT LCD</strong><p class="sub">Common repair path</p></div>
    </div>
  </section>
</main>

<footer class="wrap footer">
  <span>© 2026 RideFixer Shop. Launching soon.</span>
  <span><a href="https://ridefixer.app/">RideFixer Diagnostics</a> · <a href="mailto:ridefixer232@gmail.com">Contact</a></span>
</footer>

<script>
(function () {
  const root = document.documentElement;
  const btn = document.getElementById("themeToggle");

  function syncLabel() {
    btn.textContent = root.getAttribute("data-theme") === "dark" ? "☀️" : "🌙";
  }

  btn.addEventListener("click", function () {
    const next = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
    root.setAttribute("data-theme", next);
    localStorage.setItem("ridefixer-shop-theme", next);
    syncLabel();
  });

  syncLabel();
})();
</script>
</body>
</html>