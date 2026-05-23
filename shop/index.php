<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>RideFixer Shop - E-Bike Parts Coming Soon</title>
  <meta name="description" content="RideFixer Shop is launching soon with e-bike parts, displays, controllers, batteries, motors and repair-first replacement guidance." />
  <link rel="canonical" href="https://shop.ridefixer.app/" />
  <meta name="theme-color" content="#06101d" />
  <style>
    :root{--bg:#06101d;--bg2:#081827;--card:rgba(255,255,255,.08);--card2:rgba(255,255,255,.12);--text:#f8fbff;--muted:#a9b8ca;--line:rgba(255,255,255,.14);--brand:#00d4ff;--green:#22c7a9;--orange:#f3a45f;--shadow:0 24px 70px rgba(0,0,0,.35)}
    html[data-theme='light']{--bg:#f7fbff;--bg2:#edf4fa;--card:rgba(255,255,255,.95);--card2:#ffffff;--text:#0b1724;--muted:#5f7186;--line:rgba(8,24,39,.10);--shadow:0 18px 45px rgba(8,24,39,.08)}
    *{box-sizing:border-box}html,body{margin:0;padding:0}body{font-family:Inter,Manrope,system-ui,-apple-system,Segoe UI,sans-serif;color:var(--text);min-height:100vh;background:radial-gradient(circle at 10% 0%,rgba(0,212,255,.18),transparent 28%),radial-gradient(circle at 90% 10%,rgba(34,199,169,.14),transparent 28%),radial-gradient(circle at 75% 100%,rgba(243,164,95,.10),transparent 30%),linear-gradient(180deg,var(--bg),var(--bg2) 48%,var(--bg));overflow-x:hidden;transition:background .25s ease,color .25s ease}.wrap{width:min(1120px,92vw);margin:0 auto}.nav{height:78px;display:flex;align-items:center;justify-content:space-between;gap:18px}.brand{display:flex;align-items:center;gap:12px;font-weight:900;font-size:1.22rem;letter-spacing:-.4px}.logo{width:44px;height:44px;border-radius:14px;display:grid;place-items:center;background:linear-gradient(135deg,var(--brand),var(--green));color:#00131a;font-weight:1000;box-shadow:0 18px 48px rgba(0,212,255,.25)}.nav a{color:var(--muted);text-decoration:none;font-weight:750}.pill{padding:10px 15px;border-radius:999px;border:1px solid var(--line);background:rgba(255,255,255,.07);color:var(--text);cursor:pointer}.hero{padding:46px 0 22px;display:grid;grid-template-columns:1.1fr .9fr;gap:18px}.card{background:linear-gradient(145deg,var(--card2),var(--card));border:1px solid var(--line);border-radius:30px;box-shadow:var(--shadow);padding:30px;transition:.25s ease}.eyebrow{display:inline-flex;padding:8px 12px;border-radius:999px;border:1px solid rgba(0,212,255,.28);background:rgba(0,212,255,.10);color:#0fd6ff;font-size:.82rem;font-weight:850}h1,h2,h3{letter-spacing:-.6px;margin:0}h1{font-size:clamp(2.4rem,6vw,5.2rem);line-height:.94;margin-top:16px}.gradient{background:linear-gradient(135deg,var(--brand),#fff,var(--green));-webkit-background-clip:text;-webkit-text-fill-color:transparent}.sub{color:var(--muted);line-height:1.7}.hero .sub{font-size:1.08rem}.actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:22px}.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:13px 18px;border-radius:999px;font-weight:900;text-decoration:none}.btn-primary{background:linear-gradient(135deg,var(--brand),var(--green));color:#00131a}.btn-ghost{border:1px solid var(--line);background:rgba(255,255,255,.08);color:var(--text)}.visual{display:grid;place-items:center;text-align:center;min-height:380px;position:relative}.visual:before{content:"";position:absolute;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(0,212,255,.20),transparent 66%)}.bike{font-size:8rem;position:relative}.section{margin-top:18px}.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-top:16px}.item{padding:20px;border-radius:24px;background:rgba(255,255,255,.07);border:1px solid var(--line)}.icon{font-size:2rem;margin-bottom:10px}.mini{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-top:16px}.mini div{padding:18px;border-radius:22px;border:1px solid var(--line);background:rgba(255,255,255,.07)}.mini strong{display:block;font-size:1.4rem}.notice{text-align:center;background:linear-gradient(135deg,rgba(34,199,169,.12),rgba(0,212,255,.08))}.footer{padding:30px 0 42px;color:var(--muted);display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap}.footer a{color:inherit}@media(max-width:860px){.hero{grid-template-columns:1fr;padding-top:24px}.grid,.mini{grid-template-columns:1fr}.nav{height:auto;padding:14px 0}.nav .links{display:flex;gap:10px;flex-wrap:wrap}.card{padding:22px}.bike{font-size:6rem}.actions .btn{width:100%}}
  </style>
</head>
<body>
  <nav class="wrap nav">
    <a class="brand" href="https://shop.ridefixer.app/" style="color:inherit;text-decoration:none"><span class="logo">RF</span><span>RideFixer Shop</span></a>
    <div class="links" style="display:flex;gap:14px;align-items:center">
      <a href="#categories">Categories</a>
      <a href="#request">Request Part</a>
      <a class="pill" href="https://ridefixer.app/">Diagnostics</a>
      <button id="themeToggle" class="pill" type="button">🌙</button>
    </div>
  </nav>

  <main class="wrap"> ... </main>

  <footer class="wrap footer">
    <span>© 2026 RideFixer Shop. Launching soon.</span>
    <span><a href="https://ridefixer.app/">RideFixer Diagnostics</a> · <a href="mailto:ridefixer232@gmail.com">Contact</a></span>
  </footer>

  <script>
    (function(){
      const root=document.documentElement;
      const saved=localStorage.getItem('ridefixer-shop-theme');
      const prefers=window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light';
      const theme=saved||prefers;
      root.setAttribute('data-theme',theme);
      const btn=document.getElementById('themeToggle');
      const sync=()=>btn.textContent=root.getAttribute('data-theme')==='dark'?'☀️':'🌙';
      btn.addEventListener('click',()=>{
        const next=root.getAttribute('data-theme')==='dark'?'light':'dark';
        root.setAttribute('data-theme',next);
        localStorage.setItem('ridefixer-shop-theme',next);
        sync();
      });
      sync();
    })();
  </script>
</body>
</html>