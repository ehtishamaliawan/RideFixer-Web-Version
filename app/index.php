<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'RideFixer Web App - iOS Friendly E-Bike Toolset';
$pageDescription = 'Use RideFixer in-browser with diagnostics, maintenance tracking, battery checks, and nearby shop lookup.';
$canonical = $baseUrl . '/app';

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <h1 style="margin:0;">RideFixer Web App</h1>
  <p class="sub" style="margin-top:8px;">Built for end users: browser-friendly app for iOS and desktop, plus Play Store landing for Android installs.</p>
  <div class="cta-row" style="margin-top:12px;">
    <a class="btn btn-ghost" href="https://play.google.com/store/apps/details?id=com.bytefixer.ridefixer" target="_blank" rel="noopener">Download Android App</a>
    <a class="btn btn-brand" href="https://shop.ridefixer.app" target="_blank" rel="noopener">Shop Parts</a>
  </div>

  <div class="app-shell" id="endUserApp" style="margin-top:12px;">
    <div class="tabs">
      <button class="tab active" data-tab="garage">Garage</button>
      <button class="tab" data-tab="reminders">Reminders</button>
      <button class="tab" data-tab="errors">Error Quick Search</button>
      <button class="tab" data-tab="shops">Nearby Shops</button>
    </div>
    <div class="panel active" id="tab-garage"></div>
    <div class="panel" id="tab-reminders"></div>
    <div class="panel" id="tab-errors"></div>
    <div class="panel" id="tab-shops"></div>
  </div>
</section>
<script src="/assets/js/web-app.js"></script>
<?php require __DIR__ . '/../partials/footer.php';
