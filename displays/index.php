<?php
require __DIR__ . '/../lib/bootstrap.php';

$model = strtolower(trim($_GET['model'] ?? ''));
$route = 'index';
$current = null;

if ($model !== '') {
  if (!isset($displayCatalog[$model])) {
    http_response_code(404);
    $route = '404';
  } else {
    $route = 'detail';
    $current = $displayCatalog[$model];
  }
}

if ($route === 'detail') {
  $pageTitle = $current['name'] . ' Error Codes & P-Settings | RideFixer';
  $pageDescription = $current['summary'];
  $canonical = $baseUrl . '/displays/' . $model;
} elseif ($route === '404') {
  $pageTitle = 'Display Model Not Found | RideFixer';
  $pageDescription = 'The requested e-bike display model was not found.';
  $canonical = $baseUrl . '/displays';
} else {
  $pageTitle = 'Chinese E-Bike Display Error Codes & P-Settings | RideFixer';
  $pageDescription = 'Browse SW900, S866, KT-LCD3, KD21C and generic Chinese e-bike display error codes and P-settings.';
  $canonical = $baseUrl . '/displays';
}

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<?php if ($route === 'detail'): ?>
<section class="card">
  <span class="eyebrow"><?php echo e($current['family']); ?></span>
  <h1 style="margin-top:14px;"><?php echo e($current['name']); ?> Error Codes & P‑Settings</h1>
  <p class="sub"><?php echo e($current['summary']); ?></p>
  <div class="mini-grid">
    <div class="mini"><strong><?php echo count($current['errors']); ?></strong><span>Error code links</span></div>
    <div class="mini"><strong><?php echo count($current['settings']); ?></strong><span>P-setting links</span></div>
    <div class="mini"><strong>SEO</strong><span>Display-specific page</span></div>
  </div>
</section>

<section class="split">
  <article class="card">
    <h2>Common <?php echo e($current['name']); ?> error codes</h2>
    <div class="list">
      <?php foreach ($current['errors'] as $code): ?>
        <?php if (isset($errorCatalog['generic'][$code])): $entry = $errorCatalog['generic'][$code]; ?>
          <a class="row" href="/error-codes/generic/<?php echo e($code); ?>">
            <div class="row-top"><strong><?php echo strtoupper(e($code)); ?> - <?php echo e($entry['title']); ?></strong><span class="badge <?php echo e(badgeClass($entry['severity'])); ?>"><?php echo e($entry['severity']); ?></span></div>
            <p class="sub"><?php echo e($entry['description']); ?></p>
          </a>
        <?php endif; ?>
      <?php endforeach; ?>
    </div>
  </article>

  <aside class="card">
    <h2><?php echo e($current['name']); ?> P-settings</h2>
    <div class="list">
      <?php foreach ($current['settings'] as $setting): ?>
        <?php if (isset($settingsCatalog['generic'][$setting])): $entry = $settingsCatalog['generic'][$setting]; ?>
          <a class="row" href="/settings/generic/<?php echo e($setting); ?>">
            <div class="row-top"><strong><?php echo strtoupper(e($setting)); ?> - <?php echo e($entry['title']); ?></strong></div>
            <p class="sub"><?php echo e($entry['summary']); ?></p>
          </a>
        <?php endif; ?>
      <?php endforeach; ?>
    </div>
  </aside>
</section>

<section class="card">
  <h2>Practical notes</h2>
  <ul>
    <?php foreach ($current['notes'] as $note): ?><li><?php echo e($note); ?></li><?php endforeach; ?>
  </ul>
</section>

<?php elseif ($route === '404'): ?>
<section class="card"><h1>Display model not found</h1><p class="sub">Open the display index and choose another model.</p><a class="btn btn-brand" href="/displays">Open display index</a></section>

<?php else: ?>
<section class="card">
  <span class="eyebrow">Chinese Display Hierarchy</span>
  <h1 style="margin-top:14px;">Chinese E‑Bike Displays</h1>
  <p class="sub">Display-model pages connect real searches like SW900 E07, S866 P08 and KT-LCD3 speed limit to indexable RideFixer repair pages.</p>
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
<?php endif; ?>

<?php require __DIR__ . '/../partials/footer.php'; ?>
