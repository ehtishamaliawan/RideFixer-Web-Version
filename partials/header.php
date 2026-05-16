<?php
$currentPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$navItems = [
  ['href' => '/', 'label' => 'Home'],
  ['href' => '/app', 'label' => 'My Garage'],
  ['href' => '/error-codes', 'label' => 'Error Codes'],
  ['href' => '/settings', 'label' => 'Settings'],
  ['href' => '/battery-health-calculator', 'label' => 'Battery'],
  ['href' => '/motor-noise-diagnostic', 'label' => 'Noise'],
  ['href' => '/scan', 'label' => 'Scan'],
  ['href' => '/articles', 'label' => 'Articles'],
];

function navActiveClass(string $href, string $currentPath): string {
  if ($href === '/') {
    return $currentPath === '/' ? 'active' : '';
  }
  return str_starts_with(rtrim($currentPath, '/'), $href) ? 'active' : '';
}
?>
<header>
  <div class="wrap nav">
    <a href="/" class="brand" aria-label="RideFixer home">
      <span class="mark">RF</span>
      <span>RideFixer</span>
    </a>
    <nav class="links" aria-label="Main navigation">
      <?php foreach ($navItems as $item): ?>
        <a class="<?php echo e(navActiveClass($item['href'], $currentPath)); ?>" href="<?php echo e($item['href']); ?>"><?php echo e($item['label']); ?></a>
      <?php endforeach; ?>
      <a href="https://shop.ridefixer.app" target="_blank" rel="noopener" class="shop-pill">Shop</a>
    </nav>
  </div>
</header>
<main class="wrap">
