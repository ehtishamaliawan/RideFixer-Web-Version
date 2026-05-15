<?php
$navItems = [
  ['href' => '/', 'label' => 'Home'],
  ['href' => '/app', 'label' => 'Web App'],
  ['href' => '/error-codes', 'label' => 'Error Codes'],
  ['href' => '/settings', 'label' => 'Settings'],
  ['href' => '/battery-health-calculator', 'label' => 'Battery'],
  ['href' => '/motor-noise-diagnostic', 'label' => 'Noise'],
      ['href' => '/scan', 'label' => 'Scan'],
    ['href' => '/articles', 'label' => 'Articles'],

  
];
?>
<header>
  <div class="wrap nav">
    <a href="/" class="brand">
      <span class="mark">RF</span>
      <span>RideFixer</span>
    </a>
    <nav class="links">
      <?php foreach ($navItems as $item): ?>
        <a href="<?php echo e($item['href']); ?>"><?php echo e($item['label']); ?></a>
      <?php endforeach; ?>
      <a href="https://shop.ridefixer.app" target="_blank" rel="noopener" class="shop-pill">Shop</a>
    </nav>
  </div>
</header>
<main class="wrap">
