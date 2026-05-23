<?php

$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'] ?? 'ridefixer.app';
$baseUrl = $scheme . '://' . $host;
$year = date('Y');

$catalog = require __DIR__ . '/../config/catalog.php';
$brands = $catalog['brands'];
$brandAliases = $catalog['brandAliases'];
$errorCatalog = $catalog['errorCatalog'];
$settingsCatalog = $catalog['settingsCatalog'];
$displayCatalogPath = __DIR__ . '/../config/displays.php';
$displayCatalog = file_exists($displayCatalogPath) ? require $displayCatalogPath : [];

function e(string $value): string {
  return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function canonicalPath(string $path): string {
  if ($path === '') {
    return '/';
  }
  return '/' . trim($path, '/');
}

function badgeClass(string $severity): string {
  $severity = strtolower($severity);
  if ($severity === 'high') return 'high';
  if ($severity === 'medium') return 'medium';
  return 'low';
}

function normalizeBrand(string $brand, array $aliases): string {
  $brand = strtolower(trim($brand));
  return $aliases[$brand] ?? $brand;
}
