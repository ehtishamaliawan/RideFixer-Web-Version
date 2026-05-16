<?php
require __DIR__ . '/lib/bootstrap.php';
$pageTitle = 'RideFixer - E-Bike Error Codes & P-Settings';
$pageDescription = 'RideFixer helps e-bike riders diagnose error codes, understand Chinese display P-settings, scan display errors, compare motor noises and troubleshoot battery issues.';
$canonical = $baseUrl . '/';

require __DIR__ . '/partials/head.php';
?>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": ["WebSite", "SoftwareApplication"],
  "name": "RideFixer",
  "url": "https://ridefixer.app/",
  "description": "RideFixer helps e-bike riders diagnose error codes, understand Chinese display P-settings, scan display errors and troubleshoot motor problems.",
  "applicationCategory": "VehicleApplication",
  "operatingSystem": "Browser",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
}
</script>
<?php require __DIR__ . '/partials/header.php'; ?>

<section class="hero">
  <article class="card hero-card">
    <span class="eyebrow">Error Codes • P-Settings • OCR Scan • Motor Noise</span>
    <h1 style="margin-top:16px;">E-Bike Diagnostics <span class="gradient">For Real Riders.</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:680px;">
      RideFixer helps riders troubleshoot Chinese displays, controller settings, error codes, motor noises and battery problems using SEO-friendly repair guides and interactive tools.
    </p>
    <div class="cta-row">
      <a href="/error-codes" class="btn btn-brand">⚠️ Find Error Code</a>
      <a href="/settings" class="btn btn-dark">⚙️ Open P‑Settings</a>
      <a href="/scan" class="btn btn-dark">📷 Scan Display</a>
    </div>
    <div class="mini-grid">
      <div class="mini"><strong><?php echo array_sum(array_map('count', $errorCatalog)); ?>+</strong><span>Error codes</span></div>
      <div class="mini"><strong><?php echo count($brands); ?></strong><span>E-bike systems</span></div>
      <div class="mini"><strong>SEO</strong><span>Indexable repair pages</span></div>
    </div>
  </article>

  <aside class="card" style="display:grid;place-items:center;text-align:center;min-height:360px;">
    <div>
      <div style="font-size:9rem;line-height:1;">⚡</div>
      <h2 style="margin-top:18px;">SW900 • S866 • KT LCD</h2>
      <p class="sub">Focused on the biggest Chinese controller and display ecosystem.</p>
    </div>
  </aside>
</section>

<section class="card">
  <span class="eyebrow">RideFixer Toolkit</span>
  <h2 style="margin-top:12px;">Search, diagnose and repair.</h2>
  <p class="sub">Every major section is now structured for long-tail Google indexing and practical rider troubleshooting.</p>
  <div class="grid">
    <a href="/error-codes" class="item"><h3>⚠️ Error Codes</h3><p>Bafang, Bosch, Shimano, Yamaha, Brose and generic Chinese controller faults.</p></a>
    <a href="/settings" class="item"><h3>⚙️ P‑Settings</h3><p>SW900, S866 and KT display/controller parameter guides.</p></a>
    <a href="/motor-noise-diagnostic" class="item"><h3>🔊 Motor Noise</h3><p>Grinding, whining, clicking and hall-sensor sound diagnosis.</p></a>
    <a href="/scan" class="item"><h3>📷 OCR Scan</h3><p>Upload a display image and search detected error codes.</p></a>
    <a href="/battery-health-calculator" class="item"><h3>🔋 Battery Health</h3><p>Battery cycle estimates and replacement guidance.</p></a>
    <a href="/articles" class="item"><h3>📚 Repair Guides</h3><p>SEO-friendly repair, tuning and troubleshooting articles.</p></a>
  </div>
</section>

<section class="card">
  <h2>Most searched fixes</h2>
  <div class="grid">
    <a class="item" href="/error-codes/generic/e30"><h3>Generic E30</h3><p>Communication fault between display and controller.</p></a>
    <a class="item" href="/error-codes/generic/e07"><h3>Generic E07</h3><p>Hall sensor or motor synchronization problem.</p></a>
    <a class="item" href="/settings/generic/p08"><h3>P08 Speed Limit</h3><p>Most searched Chinese display setting.</p></a>
    <a class="item" href="/settings/generic/p14"><h3>P14 Current Limit</h3><p>Acceleration, heat and controller tuning.</p></a>
    <a class="item" href="/error-codes/bafang/30"><h3>Bafang Error 30</h3><p>Display communication and wiring troubleshooting.</p></a>
    <a class="item" href="/motor-noise-diagnostic"><h3>Motor Grinding Noise</h3><p>Diagnose worn gears and internal motor issues.</p></a>
  </div>
</section>

<?php require __DIR__ . '/partials/footer.php';
