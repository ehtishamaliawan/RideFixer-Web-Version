<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Contact RideFixer';
$pageDescription = 'Contact RideFixer for diagnostics feedback, platform support and partnership enquiries.';
$canonical = $baseUrl . '/contact';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">RideFixer Support</span>
  <h1 style="margin-top:14px;">Contact RideFixer</h1>
  <p class="sub">Questions, platform feedback, partnerships or diagnostics suggestions.</p>
</section>

<section class="grid">
  <article class="item">
    <h3>General Support</h3>
    <p>Need help understanding an error code, display model or troubleshooting workflow.</p>
    <p><strong>Email:</strong> ridefixer232@gmail.com</p>
  </article>

  <article class="item">
    <h3>Platform Feedback</h3>
    <p>Help improve RideFixer by suggesting displays, error codes, sounds or repair workflows.</p>
  </article>

  <article class="item">
    <h3>Business & Partnerships</h3>
    <p>Repair shops, fleet operators and e-bike businesses can contact RideFixer for collaboration opportunities.</p>
  </article>
</section>
<?php require __DIR__ . '/../partials/footer.php'; ?>