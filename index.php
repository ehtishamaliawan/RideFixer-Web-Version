<?php
require __DIR__ . '/lib/bootstrap.php';
$pageTitle = 'RideFixer - Smart E-Bike Diagnostics Platform';
$pageDescription = 'RideFixer is an intelligent e-bike diagnostics platform with AI-assisted display recognition, error-code troubleshooting, repair guidance and battery analysis.';
$canonical = $baseUrl . '/';

require __DIR__ . '/partials/head.php';
?>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": ["WebSite", "SoftwareApplication"],
  "name": "RideFixer",
  "url": "https://ridefixer.app/",
  "description": "RideFixer is an intelligent e-bike diagnostics platform with AI-assisted display recognition, repair guidance and smart troubleshooting workflows.",
  "applicationCategory": "VehicleApplication",
  "operatingSystem": "Browser",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
}
</script>
<?php require __DIR__ . '/partials/header.php'; ?>

<section class="hero">
  <article class="card hero-card">
    <span class="eyebrow">Smart Diagnostics • AI-Assisted Scan • Repair Guidance</span>
    <h1 style="margin-top:16px;">Intelligent <span class="gradient">E‑Bike Diagnostics</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:680px;">
      RideFixer helps riders diagnose display faults, understand error codes, compare repair sounds and follow intelligent troubleshooting workflows before replacing expensive parts.
    </p>
    <div class="cta-row">
      <a href="/error-codes" class="btn btn-brand">⚠️ Smart Error Search</a>
      <a href="/scan" class="btn btn-dark">📷 AI-Assisted Scan</a>
      <a href="/motor-noise-diagnostic" class="btn btn-dark">🔊 Acoustic Diagnostics</a>
    </div>
    <div class="mini-grid">
      <div class="mini"><strong><?php echo array_sum(array_map('count', $errorCatalog)); ?>+</strong><span>Diagnostic references</span></div>
      <div class="mini"><strong><?php echo count($brands); ?></strong><span>E-bike systems</span></div>
      <div class="mini"><strong>AI</strong><span>Assisted recognition</span></div>
    </div>
  </article>

  <aside class="card" style="display:grid;place-items:center;text-align:center;min-height:360px;">
    <div>
      <div style="font-size:9rem;line-height:1;">🚴</div>
      <h2 style="margin-top:18px;">Built for modern e-bike diagnostics</h2>
      <p class="sub">Display recognition, intelligent troubleshooting, battery analysis and rider-focused repair workflows in one platform.</p>
    </div>
  </aside>
</section>

<section class="card">
  <span class="eyebrow">RideFixer Platform</span>
  <h2 style="margin-top:12px;">Smart tools for riders and repair workflows.</h2>
  <p class="sub">Start with the problem you see or hear, then open the matching intelligent diagnostic workflow.</p>
  <div class="grid">
    <a href="/error-codes" class="item"><h3>⚠️ Smart Error Codes</h3><p>Structured diagnostics for Bafang, Bosch, Shimano, Yamaha and generic controller systems.</p></a>
    <a href="/displays" class="item"><h3>🖥️ Display Recognition</h3><p>Choose your display model for targeted error-code and P-setting guidance.</p></a>
    <a href="/motor-noise-diagnostic" class="item"><h3>🔊 Acoustic Diagnostics</h3><p>Compare real repair sounds and identify likely mechanical issues.</p></a>
    <a href="/scan" class="item"><h3>📷 AI-Assisted Scan</h3><p>Upload a display image and intelligently detect matching diagnostic references.</p></a>
    <a href="/battery-health-calculator" class="item"><h3>🔋 Battery Intelligence</h3><p>Estimate battery condition, degradation and replacement timing.</p></a>
    <a href="/settings" class="item"><h3>⚙️ Smart P‑Settings</h3><p>Controller and display parameter guidance after selecting the correct model.</p></a>
  </div>
</section>

<section class="card">
  <h2>Common rider diagnostics</h2>
  <div class="grid">
    <a class="item" href="/error-codes/generic"><h3>Generic display error</h3><p>Choose your display model first, then open the matching diagnostic flow.</p></a>
    <a class="item" href="/displays/sw900"><h3>SW900 diagnostics</h3><p>Smart troubleshooting and parameter guidance for SW900-style displays.</p></a>
    <a class="item" href="/displays/s866"><h3>S866 diagnostics</h3><p>Model-specific diagnostics and controller troubleshooting workflows.</p></a>
    <a class="item" href="/error-codes/bafang/30"><h3>Bafang Error 30</h3><p>Communication and wiring diagnostics for Bafang systems.</p></a>
    <a class="item" href="/motor-noise-diagnostic"><h3>Motor or wheel noise</h3><p>Use acoustic comparison guidance to identify likely causes.</p></a>
    <a class="item" href="/battery-health-calculator"><h3>Weak battery or low range</h3><p>Estimate battery health and identify possible degradation patterns.</p></a>
  </div>
</section>

<?php require __DIR__ . '/partials/footer.php';
