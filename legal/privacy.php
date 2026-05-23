<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Privacy Policy - RideFixer';
$pageDescription = 'RideFixer privacy policy and data handling information.';
$canonical = $baseUrl . '/legal/privacy';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Privacy & Data</span>
  <h1 style="margin-top:14px;">Privacy Policy</h1>
  <p class="sub">RideFixer respects user privacy and aims to minimise personal data collection wherever possible.</p>
</section>

<section class="grid">
  <article class="item">
    <h3>Uploaded Images</h3>
    <p>Display images uploaded for browser-based scanning may be processed temporarily for OCR and recognition workflows.</p>
  </article>

  <article class="item">
    <h3>Analytics</h3>
    <p>RideFixer may use anonymous analytics and performance tools to improve diagnostics, usability and platform reliability.</p>
  </article>

  <article class="item">
    <h3>Cookies</h3>
    <p>Basic cookies or local browser storage may be used for functionality, preferences and performance improvements.</p>
  </article>

  <article class="item">
    <h3>Third-Party Services</h3>
    <p>Some services such as app stores, OCR libraries or analytics providers may process data according to their own policies.</p>
  </article>

  <article class="item">
    <h3>Security</h3>
    <p>RideFixer aims to follow reasonable security practices but cannot guarantee complete protection against all threats or misuse.</p>
  </article>

  <article class="item">
    <h3>Policy Updates</h3>
    <p>This policy may evolve as RideFixer expands its diagnostic, scanning and intelligent troubleshooting capabilities.</p>
  </article>
</section>
<?php require __DIR__ . '/../partials/footer.php'; ?>