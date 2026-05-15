<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Battery Health Calculator - RideFixer';
$pageDescription = 'Calculate your e-bike battery health score using usage and charging habits.';
$canonical = $baseUrl . '/battery-health-calculator';

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <h1 style="margin:0;">Battery Health Calculator</h1>
  <p class="sub" style="margin-top:8px;">Interactive 6-step scoring tool adapted from RideFixer app logic.</p>
  <div class="app-shell" style="margin-top:12px;">
    <div class="panel active" id="batteryPanel"></div>
  </div>
</section>
<script src="/assets/js/battery.js"></script>
<?php require __DIR__ . '/../partials/footer.php';
