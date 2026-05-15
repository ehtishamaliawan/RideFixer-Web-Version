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
  $pageTitle = 'E-Bike Settings Guide - RideFixer';
  $pageDescription = 'Find P-settings and controller tuning guidance by e-bike brand and display family.';
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
  <h1 style="margin:0;">E-Bike Settings by Brand</h1>
  <p class="sub" style="margin-top:8px;">Navigate brand-specific setting pages with values and practical notes.</p>
  <div class="grid">
    <?php foreach ($brands as $slug => $label): ?>
      <a class="item" href="/settings/<?php echo e($slug); ?>">
        <h3><?php echo e($label); ?> Settings</h3>
        <p><?php echo count($settingsCatalog[$slug] ?? []); ?> page(s) available.</p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'brand'): ?>
<section class="card">
  <h1 style="margin:0;"><?php echo e($brands[$currentBrand]); ?> Settings Guide</h1>
  <p class="sub" style="margin-top:8px;">Open each setting page for details, values, and tuning notes.</p>
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
    <h1 style="margin:0;"><?php echo e($brands[$currentBrand]); ?> <?php echo strtoupper(e($currentCode)); ?> - <?php echo e($entry['title']); ?></h1>
    <p class="sub" style="margin-top:8px;"><?php echo e($entry['summary']); ?></p>

    <h3 style="margin:16px 0 6px;">What it does</h3>
    <p class="sub"><?php echo e($entry['details']); ?></p>

    <h3 style="margin:16px 0 6px;">Values</h3>
    <ul><?php foreach ($entry['values'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>

    <h3 style="margin:16px 0 6px;">Notes</h3>
    <ul><?php foreach ($entry['notes'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related Paths</h2>
    <div class="list">
      <a class="row" href="/settings/<?php echo e($currentBrand); ?>">View all <?php echo e($brands[$currentBrand]); ?> settings</a>
      <a class="row" href="/error-codes/<?php echo e($currentBrand); ?>">Check <?php echo e($brands[$currentBrand]); ?> error codes</a>
      <a class="row" href="https://shop.ridefixer.app" target="_blank" rel="noopener">Open RideFixer Shop</a>
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
