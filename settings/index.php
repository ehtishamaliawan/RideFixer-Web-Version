<?php
require __DIR__ . '/../lib/bootstrap.php';

$brand = isset($_GET['brand']) ? normalizeBrand($_GET['brand'], $brandAliases) : '';
$code = isset($_GET['code']) ? strtolower(trim($_GET['code'])) : '';

$featuredSettings = [
  ['href'=>'/settings/generic/p08','title'=>'P08 - Speed Limit','text'=>'Adjust assisted speed limits for controller systems.'],
  ['href'=>'/settings/generic/p14','title'=>'P14 - Current Limit','text'=>'Balance acceleration, torque and controller heat.'],
  ['href'=>'/settings/generic/p15','title'=>'P15 - Low Voltage Cutoff','text'=>'Battery protection and discharge threshold guidance.'],
  ['href'=>'/settings/generic/p06','title'=>'P06 - Wheel Size','text'=>'Fix incorrect speed and odometer readings.'],
  ['href'=>'/settings/generic/p11','title'=>'P11 - PAS Sensitivity','text'=>'Control pedal assist responsiveness.'],
  ['href'=>'/settings/generic/p12','title'=>'P12 - PAS Start Strength','text'=>'Tune smooth versus aggressive startup behavior.'],
  ['href'=>'/settings/generic/p03','title'=>'P03 - Voltage Setting','text'=>'Match controller voltage to your battery system.'],
  ['href'=>'/settings/generic/p04','title'=>'P04 - Sleep Timer','text'=>'Adjust auto shutdown timing and standby behavior.'],
];
shuffle($featuredSettings);
$featuredSettings = array_slice($featuredSettings,0,6);

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
</section>

<section class="card">
  <h2>Suggested settings today</h2>
  <p class="sub">RideFixer rotates commonly explored controller settings and tuning references.</p>
  <div class="grid">
    <?php foreach ($featuredSettings as $setting): ?>
      <a class="item" href="<?php echo e($setting['href']); ?>">
        <h3><?php echo e($setting['title']); ?></h3>
        <p><?php echo e($setting['text']); ?></p>
      </a>
    <?php endforeach; ?>
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
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related guides</h2>
    <div class="list">
      <a class="row" href="/settings/<?php echo e($currentBrand); ?>">All <?php echo e($brands[$currentBrand]); ?> settings</a>
      <a class="row" href="/error-codes/<?php echo e($currentBrand); ?>">Related error codes</a>
      <a class="row" href="/scan">Scan display for errors</a>
    </div>
  </aside>
</section>

<?php else: ?>
<section class="card">
  <h1 style="margin:0;">Settings page not found</h1>
  <div class="cta-row"><a class="btn btn-brand" href="/settings">Open Settings Index</a></div>
</section>
<?php endif; ?>

<?php require __DIR__ . '/../partials/footer.php';