<?php
require __DIR__ . '/lib/bootstrap.php';
$year = date("Y");
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>RideFixer - E-Bike Repair & Diagnostics</title>
  <meta name="description" content="RideFixer helps e-bike riders diagnose error codes, check battery health, understand motor issues, track maintenance and find repair help." />
  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website" />
  <meta property="og:title" content="RideFixer - E‑Bike Repair & Diagnostics" />
  <meta property="og:description" content="RideFixer helps e‑bike riders diagnose error codes, check battery health, understand motor issues, track maintenance and find repair help." />
  <meta property="og:url" content="https://ridefixer.app/" />
  <!-- Use the same hero image as the background for link previews -->
  <meta property="og:image" content="https://images.unsplash.com/photo-1571068316344-75bc76f77890?auto=format&fit=crop&w=1200&q=80" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="RideFixer - E‑Bike Repair & Diagnostics" />
  <meta name="twitter:description" content="RideFixer helps e‑bike riders diagnose error codes, check battery health, understand motor issues, track maintenance and find repair help." />
  <meta name="twitter:image" content="https://images.unsplash.com/photo-1571068316344-75bc76f77890?auto=format&fit=crop&w=1200&q=80" />

  <!-- Canonical URL -->
  <link rel="canonical" href="https://ridefixer.app/" />

  <!-- Structured Data (JSON-LD) -->
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": ["WebSite", "SoftwareApplication"],
      "name": "RideFixer",
      "url": "https://ridefixer.app/",
      "description": "RideFixer helps e-bike riders diagnose error codes, check battery health, understand motor issues, track maintenance and find repair help.",
      "image": "https://images.unsplash.com/photo-1571068316344-75bc76f77890?auto=format&fit=crop&w=1200&q=80",
      "applicationCategory": "VehicleApplication",
      "operatingSystem": "Browser",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      }
    }
  </script>

  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    html{scroll-behavior:smooth}
    body{
      font-family:Inter,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
      background:#06101d;
      color:#f8fbff;
      overflow-x:hidden;
    }
    a{text-decoration:none;color:inherit}
    .container{width:min(1180px,92%);margin:auto}

    :root{
      --navy:#06101d;
      --navy2:#0b1b2f;
      --cyan:#00d4ff;
      --teal:#22c7a9;
      --muted:#a9b8ca;
      --card:rgba(255,255,255,.075);
      --border:rgba(255,255,255,.13);
      --radius:26px;
    }

    header{
      position:sticky;top:0;z-index:20;
      background:rgba(6,16,29,.82);
      backdrop-filter:blur(18px);
      border-bottom:1px solid rgba(255,255,255,.08);
    }
    .nav{
      height:76px;
      display:flex;
      align-items:center;
      justify-content:space-between;
    }
    .logo{
      display:flex;
      align-items:center;
      gap:12px;
      font-size:22px;
      font-weight:850;
      letter-spacing:-.5px;
    }
    .logo-mark{
      width:44px;height:44px;border-radius:15px;
      display:grid;place-items:center;
      background:linear-gradient(135deg,var(--cyan),var(--teal));
      color:#00131a;
      font-weight:900;
      box-shadow:0 18px 45px rgba(0,212,255,.28);
    }
    .nav-links{
      display:flex;
      gap:28px;
      color:var(--muted);
      font-size:14px;
      align-items:center;
    }
    .nav-links a{
      transition:.25s ease;
      cursor:pointer;
    }
    .nav-links a:hover{color:white}
    .nav-links a.active{color:var(--cyan);font-weight:700}

    .hero{
      position:relative;
      min-height:calc(100vh - 76px);
      display:grid;
      align-items:center;
      overflow:hidden;
      isolation:isolate;
    }

    .hero::before{
      content:"";
      position:absolute;
      inset:0;
      background:
        linear-gradient(90deg,rgba(6,16,29,.96) 0%,rgba(6,16,29,.86) 42%,rgba(6,16,29,.35) 100%),
        url("https://images.unsplash.com/photo-1571068316344-75bc76f77890?auto=format&fit=crop&w=1800&q=85");
      background-size:cover;
      background-position:center right;
      z-index:-2;
    }

    .hero::after{
      content:"";
      position:absolute;
      inset:0;
      background:
        radial-gradient(circle at 20% 20%,rgba(0,212,255,.23),transparent 28%),
        radial-gradient(circle at 80% 80%,rgba(34,199,169,.18),transparent 32%);
      z-index:-1;
    }

    .hero-grid{
      display:grid;
      grid-template-columns:1.05fr .95fr;
      gap:54px;
      align-items:center;
      padding:90px 0;
    }

    .badge{
      display:inline-flex;
      padding:10px 15px;
      border:1px solid rgba(0,212,255,.28);
      border-radius:999px;
      background:rgba(0,212,255,.1);
      color:#b7f4ff;
      font-size:14px;
      margin-bottom:24px;
    }

    h1{
      font-size:clamp(44px,6vw,78px);
      line-height:.95;
      letter-spacing:-2.6px;
      max-width:760px;
      margin-bottom:24px;
    }

    .gradient{
      background:linear-gradient(135deg,var(--cyan),#fff,var(--teal));
      -webkit-background-clip:text;
      -webkit-text-fill-color:transparent;
    }

    .hero p{
      max-width:640px;
      color:#c3cedd;
      font-size:19px;
      line-height:1.7;
      margin-bottom:34px;
    }

    .actions{
      display:flex;
      flex-wrap:wrap;
      gap:14px;
      margin-bottom:34px;
    }

    .btn{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      gap:10px;
      padding:15px 24px;
      border-radius:999px;
      font-weight:800;
      transition:.25s ease;
      cursor:pointer;
      border:none;
      font-size:15px;
    }

    .btn-primary{
      background:linear-gradient(135deg,var(--cyan),var(--teal));
      color:#00131a;
      box-shadow:0 22px 50px rgba(0,212,255,.25);
    }
    .btn-primary:hover{transform:translateY(-2px)}
    
    .btn-dark{
      background:rgba(255,255,255,.08);
      border:1px solid rgba(255,255,255,.16);
      color:white;
    }
    .btn-dark:hover{
      background:rgba(255,255,255,.12);
    }

    .trust{
      display:flex;
      gap:14px;
      flex-wrap:wrap;
    }
    .trust-card{
      padding:15px 18px;
      border-radius:18px;
      background:rgba(255,255,255,.075);
      border:1px solid rgba(255,255,255,.12);
    }
    .trust-card strong{
      display:block;
      font-size:24px;
      margin-bottom:3px;
    }
    .trust-card span{
      color:var(--muted);
      font-size:13px;
    }

    section{padding:86px 0}

    .section-head{
      max-width:760px;
      margin-bottom:42px;
    }
    .section-head h2{
      font-size:clamp(34px,4vw,52px);
      letter-spacing:-1.7px;
      margin-bottom:14px;
    }
    .section-head p{
      color:var(--muted);
      font-size:17px;
      line-height:1.7;
    }

    .features{
      display:grid;
      grid-template-columns:repeat(3,1fr);
      gap:18px;
    }

    .feature{
      background:linear-gradient(145deg,rgba(255,255,255,.09),rgba(255,255,255,.045));
      border:1px solid var(--border);
      border-radius:var(--radius);
      padding:28px;
      transition:.25s ease;
      cursor:pointer;
    }
    .feature:hover{
      transform:translateY(-6px);
      border-color:rgba(0,212,255,.35);
    }
    .icon{
      width:54px;height:54px;border-radius:18px;
      background:rgba(0,212,255,.12);
      display:grid;place-items:center;
      font-size:26px;
      margin-bottom:22px;
    }
    .feature h3{
      font-size:20px;
      margin-bottom:10px;
    }
    .feature p{
      color:var(--muted);
      line-height:1.65;
      font-size:15px;
    }

    footer{
      padding:38px 0;
      color:var(--muted);
      font-size:14px;
      border-top:1px solid rgba(255,255,255,.08);
    }
    .footer-inner{
      display:flex;
      justify-content:space-between;
      flex-wrap:wrap;
      gap:18px;
    }

    @media(max-width:950px){
      .hero-grid{grid-template-columns:1fr}
      .features{grid-template-columns:1fr}
      .nav-links{gap:14px;font-size:12px}
    }

    @media(max-width:540px){
      .hero-grid{padding:62px 0}
      .actions{flex-direction:column}
      .btn{width:100%}
      .trust{display:grid;grid-template-columns:1fr 1fr}
      .nav-links{display:none}
      .features{grid-template-columns:1fr}
    }
  </style>
</head>

<body>

<header>
  <div class="container nav">
    <a class="logo" href="/">
      <span class="logo-mark">RF</span>
      <span>RideFixer</span>
    </a>

    <nav class="nav-links">
      <a href="/">Dashboard</a>
      <a href="/error-codes/">Error Codes</a>
      <a href="/battery-health-calculator/">Battery</a>
      <a href="/motor-noise-diagnostic/">Noise</a>
      <a href="/settings/">Settings</a>
    </nav>
  </div>
</header>

<main>

<section class="hero">
  <div class="container hero-grid">
    <div>
      <div class="badge">Diagnostics • Battery • Maintenance</div>
      <h1>E-Bike Diagnostics <span class="gradient">In Your Browser.</span></h1>
      <p>
        RideFixer web app: Full access to error code diagnostics, battery health checks, 
        motor noise identification, P-settings guides, and maintenance tracking. Same tools, 
        available everywhere.
      </p>
      <div class="actions">
        <a href="/error-codes/" class="btn btn-primary">
          🔍 Find Error Code
        </a>
        <a href="/battery-health-calculator/" class="btn btn-dark">
          🔋 Check Battery
        </a>
      </div>
      <div class="trust">
        <div class="trust-card">
          <strong><?php echo array_sum(array_map('count', $errorCatalog)); ?>+</strong>
          <span>Error codes</span>
        </div>
        <div class="trust-card">
          <strong>6</strong>
          <span>E-bike brands</span>
        </div>
        <div class="trust-card">
          <strong>4</strong>
          <span>Diagnostic tools</span>
        </div>
      </div>
    </div>
    <div style="text-align:center">
      <div style="font-size:200px;margin:20px 0">🚴</div>
      <p style="color:var(--muted);font-size:16px">Professional e-bike diagnostics<br/>and maintenance tools</p>
    </div>
  </div>
</section>

<section class="container">
  <div class="section-head">
    <h2>Everything to understand your e-bike.</h2>
    <p>
      Built for e-bike riders who need quick answers. Search error codes, check battery health, 
      diagnose noises, understand settings, and track maintenance—all in one place.
    </p>
  </div>
  <div class="features">
    <a href="/error-codes/" class="feature">
      <div class="icon">⚠️</div>
      <h3>Error Codes</h3>
      <p>Search <?php echo array_sum(array_map('count', $errorCatalog)); ?>+ codes across Bosch, Yamaha, Shimano, Bafang, Brose & generic systems.</p>
    </a>

    <a href="/battery-health-calculator/" class="feature">
      <div class="icon">🔋</div>
      <h3>Battery Health</h3>
      <p>Calculate battery condition and get replacement guidance.</p>
    </a>

    <a href="/motor-noise-diagnostic/" class="feature">
      <div class="icon">🔊</div>
      <h3>Noise Diagnostic</h3>
      <p>Identify mechanical issues by noise patterns.</p>
    </a>

    <a href="/settings/" class="feature">
      <div class="icon">⚙️</div>
      <h3>P-Settings Help</h3>
      <p>Understand display parameters and controller tuning.</p>
    </a>

    <div class="feature" style="opacity:.6;cursor:default">
      <div class="icon">🛠️</div>
      <h3>Maintenance Log</h3>
      <p>Track service history and set maintenance reminders. (Coming soon)</p>
    </div>

    <div class="feature" style="opacity:.6;cursor:default">
      <div class="icon">🏪</div>
      <h3>Shop</h3>
      <p>Find parts and accessories for your e-bike. (Coming soon)</p>
    </div>
  </div>
</section>

</main>

<footer>
  <div class="container footer-inner">
    <div>© <?php echo $year; ?> RideFixer. All rights reserved.</div>
    <div><a href="mailto:support@ridefixer.app">support@ridefixer.app</a></div>
  </div>
</footer>

</body>
</html>
