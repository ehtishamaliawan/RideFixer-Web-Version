<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'E‑Bike Battery Maintenance Best Practices | RideFixer';
$pageDescription = 'Learn how to charge, store and protect your e-bike battery for longer life and better safety.';
$canonical = $baseUrl . '/articles/battery-maintenance';
require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Battery Care Guide</span>
  <h1 style="margin-top:14px;">E‑Bike Battery Maintenance: Best Practices</h1>
  <p class="sub">Good battery care improves safety, range and long-term performance. These practices apply to most lithium-ion e-bike batteries.</p>
</section>

<section class="split">
  <article class="card">
    <h2>Charging</h2>
    <ul>
      <li>Use the original charger whenever possible.</li>
      <li>Charge in a dry, ventilated indoor area.</li>
      <li>Avoid charging immediately after heavy riding while the battery is hot.</li>
      <li>Do not regularly drain the battery to 0%.</li>
      <li>Partial charging between rides is healthier for lithium-ion cells.</li>
    </ul>

    <h2 style="margin-top:24px;">Storage</h2>
    <ul>
      <li>Store long-term around 30–60% charge.</li>
      <li>Avoid leaving batteries in freezing conditions or hot cars.</li>
      <li>Bring cold batteries to room temperature before charging.</li>
    </ul>

    <h2 style="margin-top:24px;">Safety</h2>
    <ul>
      <li>Never open or puncture a battery pack.</li>
      <li>Keep water away from charging ports and damaged casings.</li>
      <li>Replace swollen or damaged packs immediately.</li>
      <li>Use correct voltage chargers only.</li>
    </ul>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related tools</h2>
    <div class="list">
      <a class="row" href="/battery-health-calculator">Battery health calculator</a>
      <a class="row" href="/settings">Controller & display settings</a>
      <a class="row" href="/error-codes">Error code database</a>
      <a class="row" href="/scan">Scan display error codes</a>
    </div>
  </aside>
</section>

<?php require_once __DIR__ . '/../partials/footer.php'; ?>
