<?php
require __DIR__ . '/lib/bootstrap.php';
header('Content-Type: application/xml; charset=utf-8');

$urls = [
  '/',
  '/app',
  '/error-codes',
  '/settings',
  '/battery-health-calculator',
  '/motor-noise-diagnostic',
      '/scan',
    '/articles',
    '/articles/battery-maintenance',
];

foreach (array_keys($brands) as $brandSlug) {
  $urls[] = '/error-codes/' . $brandSlug;
  $urls[] = '/settings/' . $brandSlug;
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

echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
foreach ($urls as $url) {
  echo '<url>';
  echo '<loc>' . e($baseUrl . canonicalPath($url)) . '</loc>';
  echo '<changefreq>weekly</changefreq>';
  echo '<priority>' . ($url === '/' ? '1.0' : '0.8') . '</priority>';
  echo '</url>';
}
echo '</urlset>';
