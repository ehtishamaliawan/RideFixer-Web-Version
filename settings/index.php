<?php
require __DIR__ . '/../lib/bootstrap.php';

$brand = isset($_GET['brand']) ? normalizeBrand($_GET['brand'], $brandAliases) : '';
$code = isset($_GET['code']) ? strtolower(trim($_GET['code'])) : '';

$route = 'index';
$currentBrand = null;
$currentCode = null;

if ($brand !== '') {
  if (!isset($brands[$brand])) {
    http_response_code(404);
    $route = '404';
  } elseif ($code === '') {
    $route = 'brand';
    $currentBrand = $brand;
  } else {
    if (!isset($settingsCatalog[$brand][$code])) {
      http_response_code(404);
      $route = '404';
    } else {
      $route = 'detail';
      $currentBrand = $brand;
      $currentCode = $code;
    }
  }
}

if ($route === 'index') {
  $pageTitle = 'E-Bike P-Settings & Controller Guides - RideFixer';
  $pageDescription = 'Find SW900, S866, KT LCD and brand-specific e-bike P-settings with explanations and tuning guidance.';
  $canonical = $baseUrl . '/settings';
} elseif ($route === 'brand') {
  $pageTitle = $brands[$currentBrand] . ' E-Bike Settings Guide - RideFixer';
  $pageDescription = 'Browse ' . $brands[$currentBrand] . ' settings and tuning references.';
  $canonical = $baseUrl . '/settings/' . $currentBrand;
} elseif ($route === 'detail') {
  $entry = $settingsCatalog[$currentBrand][$currentCode];
  $pageTitle = $brands[$currentBrand] . ' ' . strtoupper($currentCode) . ' Setting - ' . $entry['title'] . ' | RideFixer';
  $pageDescription = $entry['summary'];
  $canonical = $baseUrl . '/settings/' . $currentBrand . '/' . $currentCode;
} else {
  $pageTitle = 'Settings Page Not Found - RideFixer';
  $pageDescription = 'The requested settings page was not found.';
  $canonical = $baseUrl . '/settings';
}

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<?php if ($route === 'index'): ?>
<section class="card">
  <span class="eyebrow">Chinese Display Knowledge Base</span>
  <h1 style="margin-top:14px;">SW900, S866 & E‑Bike P‑Settings</h1>
  <p class="sub" style="margin-top:8px;">RideFixer indexes controller and display settings individually so riders can search settings like P08 speed limit, P14 current limit or P15 low voltage cutoff directly from Google.</p>

  <div class="mini-grid">
    <div class="mini"><strong>SW900</strong><span>Popular delivery-bike display</span></div>
    <div class="mini"><strong>S866</strong><span>Generic controller ecosystem</span></div>
    <div class="mini"><strong>KT LCD</strong><span>KT controller parameter guides</span></div>
  </div>
</section>

<section class="card">
  <h2>Most searched settings</h2>
  <div class="grid">
    <a class="item" href="/settings/generic/p08">
      <h3>P08 - Speed Limit</h3>
      <p>One of the highest-volume Chinese display searches.</p>
    </a>
    <a class="item" href="/settings/generic/p14">
      <h3>P14 - Current Limit</h3>
      <p>Acceleration, power and controller heat balance.</p>
    </a>
    <a class="item" href="/settings/generic/p15">
      <h3>P15 - Low Voltage Cutoff</h3>
      <p>Battery protection and discharge threshold.</p>
    </a>
    <a class="item" href="/settings/generic/p06">
      <h3>P06 - Wheel Size</h3>
      <p>Fix incorrect speed and odometer readings.</p>
    </a>
    <a class="item" href="/settings/generic/p11">
      <h3>P11 - PAS Sensitivity</h3>
      <p>Control pedal assist responsiveness.</p>
    </a>
    <a class="item" href="/settings/generic/p12">
      <h3>P12 - PAS Start Strength</h3>
      <p>Smooth versus aggressive motor startup.</p>
    </a>
  </div>
</section>

<section class="card">
  <h2>Browse settings by system</h2>
  <div class="grid">
    <?php foreach ($brands as $slug => $label): ?>
      <a class="item" href="/settings/<?php echo e($slug); ?>">
        <h3><?php echo e($label); ?></h3>
        <p><?php echo count($settingsCatalog[$slug] ?? []); ?> indexable setting page(s).</p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'brand'): ?>
<section class="card">
  <span class="eyebrow">Controller & Display Settings</span>
  <h1 style="margin-top:14px;"><?php echo e($brands[$currentBrand]); ?> Settings Guide</h1>
  <p class="sub" style="margin-top:8px;">Open each setting page for values, tuning notes and practical real-world explanations.</p>
  <div class="list">
    <?php foreach ($settingsCatalog[$currentBrand] as $itemCode => $entry): ?>
      <a class="row" href="/settings/<?php echo e($currentBrand); ?>/<?php echo e($itemCode); ?>">
        <div class="row-top"><span class="code"><?php echo strtoupper(e($itemCode)); ?> - <?php echo e($entry['title']); ?></span></div>
        <p class="sub" style="margin-top:6px;"><?php echo e($entry['summary']); ?></p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'detail'): ?>
<section class="split">
  <article class="card">
    <span class="eyebrow"><?php echo e($brands[$currentBrand]); ?> Setting</span>
    <h1 style="margin-top:14px;"><?php echo strtoupper(e($currentCode)); ?> - <?php echo e($entry['title']); ?></h1>
    <p class="sub" style="margin-top:8px;"><?php echo e($entry['summary']); ?></p>

    <h3 style="margin:20px 0 8px;">What this setting controls</h3>
    <p class="sub"><?php echo e($entry['details']); ?></p>

    <h3 style="margin:20px 0 8px;">Typical values</h3>
    <ul><?php foreach ($entry['values'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>

    <h3 style="margin:20px 0 8px;">Practical notes</h3>
    <ul><?php foreach ($entry['notes'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related guides</h2>
    <div class="list">
      <a class="row" href="/settings/<?php echo e($currentBrand); ?>">All <?php echo e($brands[$currentBrand]); ?> settings</a>
      <a class="row" href="/error-codes/<?php echo e($currentBrand); ?>">Related error codes</a>
      <a class="row" href="/scan">Scan display for errors</a>
      <a class="row" href="/motor-noise-diagnostic">Motor sound diagnostics</a>
    </div>
  </aside>
</section>

<?php else: ?>
<section class="card">
  <h1 style="margin:0;">Settings page not found</h1>
  <p class="sub" style="margin-top:8px;">Try browsing from the settings index below.</p>
  <div class="cta-row"><a class="btn btn-brand" href="/settings">Open Settings Index</a></div>
</section>
<?php endif; ?>

<?php require __DIR__ . '/../partials/footer.php';
