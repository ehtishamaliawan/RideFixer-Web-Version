<?php
require __DIR__ . '/../lib/bootstrap.php';

$selectedBrand = isset($_GET['brand']) ? normalizeBrand($_GET['brand'], $brandAliases) : '';
$selectedCode = isset($_GET['code']) ? strtolower(trim($_GET['code'])) : '';
$searchQuery = trim($_GET['search'] ?? '');
$route = 'index';
$currentBrand = null;
$currentCode = null;
$currentEntry = null;

if ($selectedBrand !== '') {
  if (!isset($brands[$selectedBrand]) || !isset($errorCatalog[$selectedBrand])) {
    http_response_code(404);
    $route = '404';
  } elseif ($selectedCode === '') {
    $route = 'brand';
    $currentBrand = $selectedBrand;
  } elseif (!isset($errorCatalog[$selectedBrand][$selectedCode])) {
    http_response_code(404);
    $route = '404';
  } else {
    $route = 'detail';
    $currentBrand = $selectedBrand;
    $currentCode = $selectedCode;
    $currentEntry = $errorCatalog[$selectedBrand][$selectedCode];
  }
}

if ($route === 'detail') {
  $pageTitle = $brands[$currentBrand] . ' ' . strtoupper($currentCode) . ' Error Code - ' . $currentEntry['title'] . ' | RideFixer';
  $pageDescription = $currentEntry['description'] . ' Causes, symptoms, fixes, rideability and urgency.';
  $canonical = $baseUrl . '/error-codes/' . $currentBrand . '/' . $currentCode;
} elseif ($route === 'brand') {
  $pageTitle = $brands[$currentBrand] . ' E-Bike Error Codes | RideFixer';
  $pageDescription = 'Browse ' . $brands[$currentBrand] . ' e-bike error codes with causes, symptoms and fixes.';
  $canonical = $baseUrl . '/error-codes/' . $currentBrand;
} elseif ($route === '404') {
  $pageTitle = 'Error Code Not Found | RideFixer';
  $pageDescription = 'The requested e-bike error code was not found.';
  $canonical = $baseUrl . '/error-codes';
} else {
  $pageTitle = 'E-Bike Error Code Search | RideFixer';
  $pageDescription = 'Search e-bike error codes for Bosch, Yamaha, Shimano, Bafang, Brose and generic Chinese controllers.';
  $canonical = $baseUrl . '/error-codes';
}

function catalogResultRows(array $errorCatalog, array $brands, string $selectedBrand = '', string $searchQuery = ''): array {
  $rows = [];
  $q = strtolower(trim($searchQuery));
  foreach ($errorCatalog as $brandSlug => $codes) {
    if ($selectedBrand !== '' && $brandSlug !== $selectedBrand) continue;
    foreach ($codes as $code => $entry) {
      $haystack = strtolower($brandSlug . ' ' . $code . ' ' . $entry['title'] . ' ' . $entry['description'] . ' ' . implode(' ', $entry['causes'] ?? []) . ' ' . implode(' ', $entry['symptoms'] ?? []));
      if ($q !== '' && strpos($haystack, $q) === false) continue;
      $rows[] = ['brand' => $brandSlug, 'brandName' => $brands[$brandSlug] ?? ucfirst($brandSlug), 'code' => $code, 'entry' => $entry];
    }
  }
  return $rows;
}

$rows = catalogResultRows($errorCatalog, $brands, $route === 'brand' ? $currentBrand : '', $searchQuery);

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>

<?php if ($route === 'detail'): ?>
<section class="split">
  <article class="card">
    <span class="eyebrow"><?php echo e($brands[$currentBrand]); ?> Error Code</span>
    <h1 style="margin-top:14px;"><?php echo strtoupper(e($currentCode)); ?> - <?php echo e($currentEntry['title']); ?></h1>
    <p class="sub"><?php echo e($currentEntry['description']); ?></p>
    <div class="cta-row">
      <span class="badge <?php echo e(badgeClass($currentEntry['severity'])); ?>"><?php echo e($currentEntry['severity']); ?> severity</span>
      <span class="badge"><?php echo e($currentEntry['rideability']); ?> rideability</span>
      <span class="badge"><?php echo e($currentEntry['urgency']); ?> urgency</span>
    </div>

    <h2 style="margin-top:24px;">What it means</h2>
    <p><?php echo e($currentEntry['what']); ?></p>

    <h2 style="margin-top:24px;">Common causes</h2>
    <ul><?php foreach ($currentEntry['causes'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>

    <h2 style="margin-top:24px;">Symptoms</h2>
    <ul><?php foreach ($currentEntry['symptoms'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>

    <h2 style="margin-top:24px;">How to fix it</h2>
    <ul><?php foreach ($currentEntry['fix'] as $item): ?><li><?php echo e($item); ?></li><?php endforeach; ?></ul>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related pages</h2>
    <div class="list">
      <a class="row" href="/error-codes/<?php echo e($currentBrand); ?>">All <?php echo e($brands[$currentBrand]); ?> error codes</a>
      <a class="row" href="/settings/<?php echo e($currentBrand); ?>"><?php echo e($brands[$currentBrand]); ?> settings guide</a>
      <a class="row" href="/battery-health-calculator">Battery health calculator</a>
      <a class="row" href="/scan">Scan another display image</a>
    </div>
  </aside>
</section>

<?php elseif ($route === '404'): ?>
<section class="card">
  <h1>Error code not found</h1>
  <p class="sub">Try searching by brand, code, symptom or controller family.</p>
  <div class="cta-row"><a class="btn btn-brand" href="/error-codes">Open Error Code Search</a></div>
</section>

<?php else: ?>
<section class="card">
  <span class="eyebrow">Searchable diagnostic database</span>
  <h1 style="margin-top:14px;">🔍 Error Code Search</h1>
  <p class="sub">Every brand and every error code has its own indexable SEO page for organic traffic.</p>

  <form class="search-box" action="/error-codes" method="get" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px;">
    <?php if ($route === 'brand'): ?><input type="hidden" name="brand" value="<?php echo e($currentBrand); ?>"><?php endif; ?>
    <input type="text" name="search" placeholder="Search error code, symptom, throttle, hall, battery..." value="<?php echo e($searchQuery); ?>">
    <button class="btn btn-brand" type="submit">Search</button>
    <?php if ($searchQuery !== '' || $route === 'brand'): ?><a class="btn btn-dark" href="/error-codes">Reset</a><?php endif; ?>
  </form>
</section>

<section class="card">
  <h2>Select a brand</h2>
  <div class="grid">
    <?php foreach ($errorCatalog as $slug => $codes): ?>
      <a class="item" href="/error-codes/<?php echo e($slug); ?>">
        <h3><?php echo e($brands[$slug] ?? ucfirst($slug)); ?></h3>
        <p><?php echo count($codes); ?> indexable error code page(s).</p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<section class="card">
  <h2><?php echo $route === 'brand' ? e($brands[$currentBrand]) . ' error codes' : 'All error codes'; ?></h2>
  <?php if (empty($rows)): ?>
    <p class="sub">No matching error code found. Try a different keyword.</p>
  <?php else: ?>
    <div class="grid">
      <?php foreach ($rows as $row): $entry = $row['entry']; ?>
        <a class="item" href="/error-codes/<?php echo e($row['brand']); ?>/<?php echo e($row['code']); ?>">
          <div class="row-top">
            <span class="code"><?php echo strtoupper(e($row['code'])); ?></span>
            <span class="badge <?php echo e(badgeClass($entry['severity'])); ?>"><?php echo e($entry['severity']); ?></span>
          </div>
          <h3><?php echo e($entry['title']); ?></h3>
          <p><?php echo e($row['brandName']); ?> · <?php echo e($entry['description']); ?></p>
        </a>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>
<?php endif; ?>

<?php require __DIR__ . '/../partials/footer.php';
