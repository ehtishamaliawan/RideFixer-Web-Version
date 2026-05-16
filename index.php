<?php
require __DIR__ . '/lib/bootstrap.php';
$pageTitle = 'RideFixer - E-Bike Repair & Diagnostics';
$pageDescription = 'RideFixer helps e-bike riders diagnose error codes, check battery health, understand motor issues, scan display errors, track maintenance and find repair help.';
$canonical = $baseUrl . '/';

require __DIR__ . '/partials/head.php';
?>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": ["WebSite", "SoftwareApplication"],
  "name": "RideFixer",
  "url": "https://ridefixer.app/",
  "description": "RideFixer helps e-bike riders diagnose error codes, check battery health, understand motor issues, scan display errors, track maintenance and find repair help.",
  "applicationCategory": "VehicleApplication",
  "operatingSystem": "Browser",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
}
</script>
<?php require __DIR__ . '/partials/header.php'; ?>

<section class="hero">
  <article class="card hero-card">
    <span class="eyebrow">Diagnostics • Battery • OCR Scan • Maintenance</span>
    <h1 style="margin-top:16px;">E-Bike Diagnostics <span class="gradient">In Your Browser.</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:680px;">
      RideFixer gives e-bike riders fast access to error-code lookup, battery health checks, motor-noise guidance, P-settings, OCR display scanning, maintenance tools and repair content.
    </p>
    <div class="cta-row">
      <a href="/error-codes" class="btn btn-brand">🔍 Find Error Code</a>
      <a href="/scan" class="btn btn-dark">📷 Scan Display</a>
      <a href="/battery-health-calculator" class="btn btn-dark">🔋 Check Battery</a>
    </div>
    <div class="mini-grid">
      <div class="mini"><strong><?php echo array_sum(array_map('count', $errorCatalog)); ?>+</strong><span>Error codes</span></div>
      <div class="mini"><strong><?php echo count($brands); ?></strong><span>E-bike brands</span></div>
      <div class="mini"><strong>8</strong><span>Web tools & guides</span></div>
    </div>
  </article>

  <aside class="card" style="display:grid;place-items:center;text-align:center;min-height:360px;">
    <div>
      <div style="font-size:9rem;line-height:1;">🚴</div>
      <h2 style="margin-top:18px;">Built for real riders</h2>
      <p class="sub">Delivery riders, commuters, DIY repairers and small e-bike shops.</p>
    </div>
  </aside>
</section>

<section class="card">
  <span class="eyebrow">RideFixer Toolkit</span>
  <h2 style="margin-top:12px;">Everything to understand your e-bike.</h2>
  <p class="sub">All main website sections now use the same shared navigation and theme.</p>
  <div class="grid">
    <a href="/error-codes" class="item"><h3>⚠️ Error Codes</h3><p>Search brand-specific error codes and practical fixes.</p></a>
    <a href="/battery-health-calculator" class="item"><h3>🔋 Battery Health</h3><p>Calculate battery condition and replacement guidance.</p></a>
    <a href="/motor-noise-diagnostic" class="item"><h3>🔊 Noise Diagnostic</h3><p>Match common sounds with likely mechanical causes.</p></a>
    <a href="/settings" class="item"><h3>⚙️ P-Settings</h3><p>Understand controller and display settings.</p></a>
    <a href="/scan" class="item"><h3>📷 OCR Scan</h3><p>Upload a display photo and detect possible error codes.</p></a>
    <a href="/articles" class="item"><h3>📚 Articles</h3><p>SEO-friendly guides for battery care, repair and diagnostics.</p></a>
  </div>
</section>

<section class="kicker">
  <div>
    <h2 style="margin:0;">Use the full web app experience</h2>
    <p style="margin:8px 0 0;color:#d8f8fb;">Garage, reminders, quick lookup and nearby shop flow.</p>
  </div>
  <a class="btn btn-brand" href="/app">Open Web App</a>
</section>

<?php require __DIR__ . '/partials/footer.php';
