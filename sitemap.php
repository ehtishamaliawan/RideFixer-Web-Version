<?php
require __DIR__ . '/lib/bootstrap.php';
header('Content-Type: application/xml; charset=utf-8');

$urls = [
  '/',
  '/error-codes',
  '/settings',
  '/displays',
  '/battery-health-calculator',
  '/motor-noise-diagnostic',
  '/scan',
  '/articles',
  '/about',
  '/contact',
  '/legal/disclaimer',
  '/legal/privacy',
  '/articles/battery-maintenance',
  '/articles/cassette-vs-freewheel',
];

foreach (array_keys($brands) as $brandSlug) {
  $urls[] = '/error-codes/' . $brandSlug;
  $urls[] = '/settings/' . $brandSlug;
}

foreach ($displayCatalog as $displaySlug => $display) {
  $urls[] = '/displays/' . $displaySlug;
  $urls[] = '/displays/' . $displaySlug . '/error-codes';
  $urls[] = '/displays/' . $displaySlug . '/p-settings';
}

foreach ($errorCatalog as $brandSlug => $codes) {
  foreach (array_keys($codes) as $codeSlug) {
    $urls[] = '/error-codes/' . $brandSlug . '/' . $codeSlug;
  }
}

foreach ($settingsCatalog as $brandSlug => $codes) {
  foreach (array_keys($codes) as $codeSlug) {
    $urls[] = '/settings/' . $brandSlug . '/' . $codeSlug;
  }
}

$urls = array_unique($urls);

$priorities = [
  '/' => '1.0',
  '/error-codes' => '0.95',
  '/displays' => '0.95',
  '/settings' => '0.92',
  '/scan' => '0.90',
  '/motor-noise-diagnostic' => '0.88',
  '/battery-health-calculator' => '0.86',
  '/articles/cassette-vs-freewheel' => '0.84',
];

echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';

foreach ($urls as $url) {
  $priority = $priorities[$url] ?? '0.80';

  echo '<url>';
  echo '<loc>' . e($baseUrl . canonicalPath($url)) . '</loc>';
  echo '<changefreq>weekly</changefreq>';
  echo '<priority>' . $priority . '</priority>';
  echo '</url>';
}

echo '</urlset>';
