<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Motor Noise Diagnostic - RideFixer';
$pageDescription = 'Match motor sounds to likely issues and get quick repair guidance.';
$canonical = $baseUrl . '/motor-noise-diagnostic';

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <h1 style="margin:0;">Motor Noise Diagnostic</h1>
  <p class="sub" style="margin-top:8px;">Use sound-pattern guidance for common e-bike noise problems.</p>
  <div class="grid" style="margin-top:12px;">
    <article class="item"><h3>Motor gears</h3><p>Grinding or whirring under load. Check internal gear wear and lubrication.</p></article>
    <article class="item"><h3>Derailleur chatter</h3><p>Clicking while pedaling. Re-index shifting and inspect hanger alignment.</p></article>
    <article class="item"><h3>Loose spokes</h3><p>Ping or creak under force. Check spoke tension and wheel trueness.</p></article>
    <article class="item"><h3>Rotor rub</h3><p>Repeated scrape each wheel rotation. Center caliper and true rotor.</p></article>
    <article class="item"><h3>Next step</h3><p>Use settings and error pages to isolate electrical vs mechanical root causes.</p></article>
    <article class="item"><h3>Shop conversion</h3><p>Need parts now? Jump to shop.ridefixer.app from diagnostics flow.</p></article>
  </div>
</section>
<?php require __DIR__ . '/../partials/footer.php';
