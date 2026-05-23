<?php
require __DIR__ . '/../lib/bootstrap.php';

$model = strtolower(trim($_GET['model'] ?? ''));
$section = strtolower(trim($_GET['section'] ?? ''));
$code = strtolower(trim($_GET['code'] ?? ''));
$route = 'index';
$current = null;
$currentEntry = null;

if ($model !== '') {
  if (!isset($displayCatalog[$model])) {
    http_response_code(404);
    $route = '404';
  } else {
    $current = $displayCatalog[$model];
    $route = 'model';
    if ($section === 'errors') {
      $route = 'errors';
    } elseif ($section === 'settings') {
      $route = 'settings';
    } elseif ($section === 'error' && $code !== '') {
      if (!in_array($code, $current['errors'], true) || !isset($errorCatalog['generic'][$code])) {
        http_response_code(404);
        $route = '404';
      } else {
        $route = 'error-detail';
        $currentEntry = $errorCatalog['generic'][$code];
      }
    } elseif ($section === 'setting' && $code !== '') {
      if (!in_array($code, $current['settings'], true) || !isset($settingsCatalog['generic'][$code])) {
        http_response_code(404);
        $route = '404';
      } else {
        $route = 'setting-detail';
        $currentEntry = $settingsCatalog['generic'][$code];
      }
    }
  }
}

if ($route === 'model') {
  $pageTitle = $current['name'] . ' Guide | RideFixer';
  $pageDescription = $current['summary'];
  $canonical = $baseUrl . '/displays/' . $model;
} elseif ($route === 'errors') {
  $pageTitle = $current['name'] . ' Error Codes | RideFixer';
  $pageDescription = 'Browse common ' . $current['name'] . ' e-bike display error codes with causes and fixes.';
  $canonical = $baseUrl . '/displays/' . $model . '/error-codes';
} elseif ($route === 'settings') {
  $pageTitle = $current['name'] . ' P-Settings | RideFixer';
  $pageDescription = 'Browse ' . $current['name'] . ' P-settings for wheel size, voltage, speed limit, PAS and current control.';
  $canonical = $baseUrl . '/displays/' . $model . '/p-settings';
} elseif ($route === 'error-detail') {
  $pageTitle = $current['name'] . ' ' . strtoupper($code) . ' Error Code - ' . $currentEntry['title'] . ' | RideFixer';
  $pageDescription = $currentEntry['description'];
  $canonical = $baseUrl . '/displays/' . $model . '/error-codes/' . $code;
} elseif ($route === 'setting-detail') {
  $pageTitle = $current['name'] . ' ' . strtoupper($code) . ' Setting - ' . $currentEntry['title'] . ' | RideFixer';
  $pageDescription = $currentEntry['summary'];
  $canonical = $baseUrl . '/displays/' . $model . '/p-settings/' . $code;
} elseif ($route === '404') {
  $pageTitle = 'Display Page Not Found | RideFixer';
  $pageDescription = 'The requested display page was not found.';
  $canonical = $baseUrl . '/displays';
} else {
  $pageTitle = 'Chinese E-Bike Displays | RideFixer';
  $pageDescription = 'Choose your e-bike display model first, then open error codes or P-settings.';
  $canonical = $baseUrl . '/displays';
}

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<?php if ($route === 'index'): ?>
<section class="card">
  <span class="eyebrow">Chinese / Generic Display System</span>
  <h1 style="margin-top:14px;">Choose Your Display Model</h1>
  <p class="sub">Start like the app: select your display model first, then open its error codes or P-settings.</p>
</section>
<section class="card">
  <div class="grid">
    <?php foreach ($displayCatalog as $slug => $display): ?>
      <a class="item" href="/displays/<?php echo e($slug); ?>">
        <h3><?php echo e($display['name']); ?></h3>
        <p><?php echo e($display['summary']); ?></p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'model'): ?>
<section class="card">
  <span class="eyebrow"><?php echo e($current['family']); ?></span>
  <h1 style="margin-top:14px;"><?php echo e($current['name']); ?></h1>
  <p class="sub"><?php echo e($current['summary']); ?></p>
  <div class="grid">
    <a class="item" href="/displays/<?php echo e($model); ?>/error-codes">
      <h3>Error Codes</h3>
      <p><?php echo count($current['errors']); ?> common codes for this display family.</p>
    </a>
    <a class="item" href="/displays/<?php echo e($model); ?>/p-settings">
      <h3>P-Settings</h3>
      <p><?php echo count($current['settings']); ?> controller/display parameters for this model.</p>
    </a>
    <a class="item" href="/scan">
      <h3>Scan Display</h3>
      <p>Upload a display photo and detect possible error codes.</p>
    </a>
  </div>
</section>
<section class="card">
  <h2>Practical notes</h2>
  <ul><?php foreach ($current['notes'] as $note): ?><li><?php echo e($note); ?></li><?php endforeach; ?></ul>
</section>

<?php elseif ($route === 'errors'): ?>
<section class="card">
  <span class="eyebrow"><?php echo e($current['name']); ?></span>
  <h1 style="margin-top:14px;">Error Codes</h1>
  <p class="sub">Open each code for symptoms, causes and repair suggestions.</p>
</section>
<section class="card">
  <div class="grid">
    <?php foreach ($current['errors'] as $itemCode): ?>
      <?php if (isset($errorCatalog['generic'][$itemCode])): $entry = $errorCatalog['generic'][$itemCode]; ?>
        <a class="item" href="/displays/<?php echo e($model); ?>/error-codes/<?php echo e($itemCode); ?>">
          <div class="row-top"><span class="code"><?php echo strtoupper(e($itemCode)); ?></span><span class="badge <?php echo e(badgeClass($entry['severity'])); ?>"><?php echo e($entry['severity']); ?></span></div>
          <h3><?php echo e($entry['title']); ?></h3>
          <p><?php echo e($entry['description']); ?></p>
        </a>
      <?php endif; ?>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'settings'): ?>
<section class="card">
  <span class="eyebrow"><?php echo e($current['name']); ?></span>
  <h1 style="margin-top:14px;">P-Settings</h1>
  <p class="sub">Open each setting for values, meaning and safe adjustment notes.</p>
</section>
<section class="card">
  <div class="grid">
    <?php foreach ($current['settings'] as $itemCode): ?>
      <?php if (isset($settingsCatalog['generic'][$itemCode])): $entry = $settingsCatalog['generic'][$itemCode]; ?>
        <a class="item" href="/displays/<?php echo e($model); ?>/p-settings/<?php echo e($itemCode); ?>">
          <div class="row-top"><span class="code"><?php echo strtoupper(e($itemCode)); ?></span></div>
          <h3><?php echo e($entry['title']); ?></h3>
          <p><?php echo e($entry['summary']); ?></p>
        </a>
      <?php endif; ?>
    <?php endforeach; ?>
  </div>
</section>

<?php elseif ($route === 'error-detail'): ?>
<section class="split">
  <article class="card">
    <span class="eyebrow"><?php echo e($current['name']); ?> Error Code</span>
    <h1 style="margin-top:14px;"><?php echo strtoupper(e($code)); ?> - <?php echo e($currentEntry['title']); ?></h1>
    <p class="sub"><?php echo e($currentEntry['description']); ?></p>
    <div class="cta-row"><span class="badge <?php echo e(badgeClass($currentEntry['severity'])); ?>"><?php echo e($currentEntry['severity']); ?> severity</span><span class="badge"><?php echo e($currentEntry['rideability']); ?></span></div>
    <h2 style="margin-top:24px;">What it means</h2><p><?php echo e($currentEntry['what']); ?></p>
    <h2 style="margin-top:24px;">Common causes</h2><ul><?php foreach ($currentEntry['causes'] as $x): ?><li><?php echo e($x); ?></li><?php endforeach; ?></ul>
    <h2 style="margin-top:24px;">Symptoms</h2><ul><?php foreach ($currentEntry['symptoms'] as $x): ?><li><?php echo e($x); ?></li><?php endforeach; ?></ul>
    <h2 style="margin-top:24px;">Suggested fixes</h2><ul><?php foreach ($currentEntry['fix'] as $x): ?><li><?php echo e($x); ?></li><?php endforeach; ?></ul>
  </article>
  <aside class="card"><h2 style="margin-top:0;">More for <?php echo e($current['name']); ?></h2><div class="list"><a class="row" href="/displays/<?php echo e($model); ?>/error-codes">All error codes</a><a class="row" href="/displays/<?php echo e($model); ?>/p-settings">P-settings</a><a class="row" href="/scan">Scan another display</a></div></aside>
</section>

<?php elseif ($route === 'setting-detail'): ?>
<section class="split">
  <article class="card">
    <span class="eyebrow"><?php echo e($current['name']); ?> P-Setting</span>
    <h1 style="margin-top:14px;"><?php echo strtoupper(e($code)); ?> - <?php echo e($currentEntry['title']); ?></h1>
    <p class="sub"><?php echo e($currentEntry['summary']); ?></p>
    <h2 style="margin-top:24px;">What it controls</h2><p><?php echo e($currentEntry['details']); ?></p>
    <h2 style="margin-top:24px;">Typical values</h2><ul><?php foreach ($currentEntry['values'] as $x): ?><li><?php echo e($x); ?></li><?php endforeach; ?></ul>
    <h2 style="margin-top:24px;">Practical notes</h2><ul><?php foreach ($currentEntry['notes'] as $x): ?><li><?php echo e($x); ?></li><?php endforeach; ?></ul>
  </article>
  <aside class="card"><h2 style="margin-top:0;">More for <?php echo e($current['name']); ?></h2><div class="list"><a class="row" href="/displays/<?php echo e($model); ?>/p-settings">All P-settings</a><a class="row" href="/displays/<?php echo e($model); ?>/error-codes">Error codes</a><a class="row" href="/settings/generic/<?php echo e($code); ?>">General setting guide</a></div></aside>
</section>

<?php else: ?>
<section class="card"><h1>Display page not found</h1><p class="sub">Please choose a display model again.</p><a class="btn btn-brand" href="/displays">Open Display Models</a></section>
<?php endif; ?>

<?php require __DIR__ . '/../partials/footer.php'; ?>
