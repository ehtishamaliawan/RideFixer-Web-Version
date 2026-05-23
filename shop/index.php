<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'RideFixer Shop - E-Bike Parts & Replacement Components';
$pageDescription = 'Shop displays, controllers, batteries, brakes, motors and essential e-bike parts.';
$canonical = 'https://shop.ridefixer.app/';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<section class="hero">
  <article class="card hero-card">
    <span class="eyebrow">RideFixer Shop • E-Bike Parts</span>
    <h1 style="margin-top:16px;">Smart <span class="gradient">E‑Bike Parts Store</span></h1>
    <p class="sub" style="font-size:1.08rem;max-width:680px;">
      Browse displays, batteries, controllers, motors and common replacement parts built around repair workflows.
    </p>
    <div class="cta-row">
      <a href="#categories" class="btn btn-brand">Browse Parts</a>
      <a href="https://ridefixer.app/error-codes" class="btn btn-dark">Match Fault → Part</a>
    </div>
  </article>

  <aside class="card" style="display:grid;place-items:center;text-align:center;min-height:320px;">
    <div>
      <div style="font-size:8rem;line-height:1;">🛒</div>
      <h2>Repair-first e-bike shop</h2>
      <p class="sub">Built around diagnostics, compatibility and common replacement paths.</p>
    </div>
  </aside>
</section>

<section id="categories" class="card">
  <h2>Popular categories</h2>
  <div class="grid">
    <a class="item" href="#">🔋 Batteries</a>
    <a class="item" href="#">🖥 Displays</a>
    <a class="item" href="#">⚙️ Controllers</a>
    <a class="item" href="#">🎛 Throttles</a>
    <a class="item" href="#">🛞 Motors</a>
    <a class="item" href="#">🛠 Accessories</a>
  </div>
</section>

<section class="card">
  <h2>Trusted compatibility</h2>
  <div class="mini-grid">
    <div class="mini"><strong>SW900</strong><span>Display ecosystem</span></div>
    <div class="mini"><strong>S866</strong><span>Controllers & displays</span></div>
    <div class="mini"><strong>KT LCD</strong><span>Replacement workflows</span></div>
  </div>
</section>

<?php require __DIR__ . '/../partials/footer.php'; ?>