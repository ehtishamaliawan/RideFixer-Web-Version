<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'About RideFixer';
$pageDescription = 'Learn about the RideFixer intelligent e-bike diagnostics platform.';
$canonical = $baseUrl . '/about';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">RideFixer Platform</span>
  <h1 style="margin-top:14px;">About RideFixer</h1>
  <p class="sub">RideFixer is building an intelligent diagnostics platform for the fragmented global e-bike ecosystem.</p>
</section>

<section class="grid">
  <article class="item">
    <h3>Smart Diagnostics</h3>
    <p>RideFixer combines structured troubleshooting, OCR-assisted recognition, repair guidance and rider workflows into one platform.</p>
  </article>

  <article class="item">
    <h3>Display & Controller Focus</h3>
    <p>The platform focuses heavily on Chinese and generic e-bike display systems such as SW900, S866, KT LCD and related controller ecosystems.</p>
  </article>

  <article class="item">
    <h3>Repair Knowledge Base</h3>
    <p>RideFixer continuously expands its error-code references, diagnostic guides, sound libraries and tuning documentation.</p>
  </article>

  <article class="item">
    <h3>AI-Assisted Workflows</h3>
    <p>RideFixer uses intelligent matching and assisted recognition workflows to help riders identify systems and possible faults faster.</p>
  </article>

  <article class="item">
    <h3>Built for Riders</h3>
    <p>The platform is designed for commuters, delivery riders, enthusiasts and repair technicians who need practical troubleshooting support.</p>
  </article>

  <article class="item">
    <h3>Future Platform Vision</h3>
    <p>RideFixer aims to evolve into a broader intelligent diagnostics ecosystem for modern electric mobility systems.</p>
  </article>
</section>
<?php require __DIR__ . '/../partials/footer.php'; ?>