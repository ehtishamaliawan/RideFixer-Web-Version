<?php
require __DIR__ . '/lib/bootstrap.php';
$pageTitle = 'RideFixer - E-Bike Diagnostics & Repair Help';
$pageDescription = 'RideFixer helps e-bike riders diagnose error codes, scan display faults, compare real repair sounds, check battery health and understand controller settings.';
$canonical = $baseUrl . '/';

require __DIR__ . '/partials/head.php';
?>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": ["WebSite", "SoftwareApplication"],
  "name": "RideFixer",
  "url": "https://ridefixer.app/",
  "description": "RideFixer helps e-bike riders diagnose error codes, scan display faults, compare real repair sounds, check battery health and understand controller settings.",
  "applicationCategory": "VehicleApplication",
  "operatingSystem": "Browser",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
}
</script>
<?php require __DIR__ . '/partials/header.php'; ?>

<section class="hero">
  <article class="card hero-card">
    <span class="eyebrow">Error Codes • Scan • Battery • Motor Noise • Settings</span>
    <h1 style="margin-top:16px;">E-Bike Diagnostics <span class="gradient">Made Simple.</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:680px;">
      RideFixer helps riders understand faults, check common symptoms, compare real repair sounds and find practical next steps before replacing parts or visiting a repair shop.
    </p>
    <div class="cta-row">
      <a href="/error-codes" class="btn btn-brand">⚠️ Find Error Code</a>
      <a href="/scan" class="btn btn-dark">📷 Scan Display</a>
      <a href="/motor-noise-diagnostic" class="btn btn-dark">🔊 Compare Sounds</a>
    </div>
    <div class="mini-grid">
      <div class="mini"><strong><?php echo array_sum(array_map('count', $errorCatalog)); ?>+</strong><span>Error codes</span></div>
      <div class="mini"><strong><?php echo count($brands); ?></strong><span>E-bike systems</span></div>
      <div class="mini"><strong>4</strong><span>Real sound samples</span></div>
    </div>
  </article>

  <aside class="card" style="display:grid;place-items:center;text-align:center;min-height:360px;">
    <div>
      <div style="font-size:9rem;line-height:1;">🚴</div>
      <h2 style="margin-top:18px;">Built for everyday e-bike problems</h2>
      <p class="sub">Battery issues, display errors, motor noises, controller faults and repair guidance in one place.</p>
    </div>
  </aside>
</section>

<section class="card">
  <span class="eyebrow">RideFixer Toolkit</span>
  <h2 style="margin-top:12px;">Search, diagnose and repair.</h2>
  <p class="sub">Start with the problem you see or hear, then open the matching diagnostic guide.</p>
  <div class="grid">
    <a href="/error-codes" class="item"><h3>⚠️ Error Codes</h3><p>Bafang, Bosch, Shimano, Yamaha, Brose and generic controller faults.</p></a>
    <a href="/displays" class="item"><h3>🖥️ Display Models</h3><p>Choose your display first for model-specific error codes and P-settings.</p></a>
    <a href="/motor-noise-diagnostic" class="item"><h3>🔊 Motor & Bike Noise</h3><p>Compare real repair sounds for gears, spokes, brakes and drivetrain issues.</p></a>
    <a href="/scan" class="item"><h3>📷 OCR Scan</h3><p>Upload a display image and search detected error codes.</p></a>
    <a href="/battery-health-calculator" class="item"><h3>🔋 Battery Health</h3><p>Battery cycle estimates and replacement guidance.</p></a>
    <a href="/settings" class="item"><h3>⚙️ P‑Settings</h3><p>Controller/display parameter guides after selecting the correct model.</p></a>
  </div>
</section>

<section class="card">
  <h2>Common rider problems</h2>
  <div class="grid">
    <a class="item" href="/error-codes/generic"><h3>Generic display error</h3><p>Choose your display model first, then open the matching error code.</p></a>
    <a class="item" href="/displays/sw900"><h3>SW900 display help</h3><p>Error codes and P-settings for common SW900-style displays.</p></a>
    <a class="item" href="/displays/s866"><h3>S866 display help</h3><p>Model-specific settings and common controller faults.</p></a>
    <a class="item" href="/error-codes/bafang/30"><h3>Bafang Error 30</h3><p>Display communication and wiring troubleshooting.</p></a>
    <a class="item" href="/motor-noise-diagnostic"><h3>Motor or wheel noise</h3><p>Compare real sounds and check likely causes.</p></a>
    <a class="item" href="/battery-health-calculator"><h3>Weak battery or low range</h3><p>Estimate battery condition and possible replacement timing.</p></a>
  </div>
</section>

<?php require __DIR__ . '/partials/footer.php';
