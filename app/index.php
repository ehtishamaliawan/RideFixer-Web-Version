<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'My Garage - RideFixer E-Bike App';
$pageDescription = 'Save your e-bike, maintenance reminders, battery checks, diagnostic history and quick repair tools in RideFixer My Garage.';
$canonical = $baseUrl . '/app';

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Personal E-Bike Workspace</span>
  <h1 style="margin-top:14px;">My Garage</h1>
  <p class="sub" style="margin-top:8px;">A browser-friendly version of the RideFixer app: save bikes, track battery health, log maintenance, open diagnostics, store notes and find repair help.</p>
  <div class="cta-row" style="margin-top:12px;">
    <a class="btn btn-brand" href="/scan">Scan Error Code</a>
    <a class="btn btn-dark" href="/error-codes">Open Error Database</a>
    <a class="btn btn-dark" href="/settings">P-Settings Guide</a>
  </div>

  <div class="mini-grid">
    <div class="mini"><strong>Local</strong><span>Saved in this browser</span></div>
    <div class="mini"><strong>SEO</strong><span>Links to indexable guides</span></div>
    <div class="mini"><strong>Fast</strong><span>No login required yet</span></div>
  </div>

  <div class="app-shell" id="endUserApp" style="margin-top:18px;">
    <div class="tabs">
      <button class="tab active" data-tab="garage">Garage</button>
      <button class="tab" data-tab="battery">Battery</button>
      <button class="tab" data-tab="reminders">Maintenance</button>
      <button class="tab" data-tab="diagnostics">Diagnostics</button>
      <button class="tab" data-tab="errors">Quick Lookup</button>
      <button class="tab" data-tab="shops">Nearby Shops</button>
      <button class="tab" data-tab="data">Data</button>
    </div>
    <div class="panel active" id="tab-garage"></div>
    <div class="panel" id="tab-battery"></div>
    <div class="panel" id="tab-reminders"></div>
    <div class="panel" id="tab-diagnostics"></div>
    <div class="panel" id="tab-errors"></div>
    <div class="panel" id="tab-shops"></div>
    <div class="panel" id="tab-data"></div>
  </div>
</section>
<script src="/assets/js/web-app.js"></script>
<?php require __DIR__ . '/../partials/footer.php';
