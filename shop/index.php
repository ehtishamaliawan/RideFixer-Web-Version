<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'RideFixer Shop - Coming Soon';
$pageDescription = 'RideFixer Shop is launching soon for e-bike parts, accessories and repair workflows.';
$canonical = 'https://shop.ridefixer.app/';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<section class="hero">
  <article class="card hero-card" style="text-align:center;">
    <span class="eyebrow">RideFixer Shop</span>
    <h1 style="margin-top:16px;">Store Launching <span class="gradient">Soon</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:760px;margin:0 auto;">
      We are preparing a dedicated e-bike parts marketplace focused on repair workflows, compatibility and trusted replacement components.
    </p>

    <div class="cta-row" style="justify-content:center;">
      <a href="https://ridefixer.app/error-codes" class="btn btn-brand">Go to Diagnostics</a>
      <a href="mailto:support@ridefixer.app" class="btn btn-dark">Request a Part</a>
    </div>
  </article>
</section>

<section class="card">
  <h2>What’s coming</h2>
  <div class="grid">
    <div class="item">🔋 Batteries</div>
    <div class="item">🖥 Displays</div>
    <div class="item">⚙️ Controllers</div>
    <div class="item">🛞 Motors</div>
    <div class="item">🛠 Accessories</div>
    <div class="item">📦 Repair-first replacement parts</div>
  </div>
</section>

<section class="card" style="text-align:center;">
  <h2>Built for riders & repair shops</h2>
  <p class="sub">A focused marketplace connected to RideFixer diagnostics and compatibility workflows.</p>
</section>

<?php require __DIR__ . '/../partials/footer.php'; ?>