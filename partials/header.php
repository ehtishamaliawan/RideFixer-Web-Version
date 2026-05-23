<?php
$currentPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$appIcon = '/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png';
$playStoreUrl = 'https://play.google.com/store/apps/details?id=com.bytefixer.ridefixer';
$navItems = [
  ['href' => '/', 'label' => 'Home'],
  ['href' => '/error-codes', 'label' => 'Error Codes'],
  ['href' => '/displays', 'label' => 'Displays'],
  ['href' => '/settings', 'label' => 'P-Settings'],
  ['href' => '/motor-noise-diagnostic', 'label' => 'Motor Noise'],
  ['href' => '/scan', 'label' => 'Scan'],
  ['href' => '/battery-health-calculator', 'label' => 'Battery'],
  ['href' => '/articles', 'label' => 'Guides'],
];
function navActiveClass(string $href, string $currentPath): string {
  if ($href === '/') return $currentPath === '/' ? 'active' : '';
  return str_starts_with(rtrim($currentPath, '/'), $href) ? 'active' : '';
}
?>
<header>
  <div class="wrap nav" style="position:relative;">
    <a href="/" class="brand" aria-label="RideFixer home">
      <img src="<?php echo e($appIcon); ?>" alt="RideFixer" style="width:42px;height:42px;border-radius:12px;box-shadow:0 10px 28px rgba(0,0,0,.28);" />
      <span>RideFixer</span>
    </a>

    <nav class="links desktop-nav" aria-label="Main navigation">
      <?php foreach ($navItems as $item): ?>
        <a class="<?php echo e(navActiveClass($item['href'], $currentPath)); ?>" href="<?php echo e($item['href']); ?>"><?php echo e($item['label']); ?></a>
      <?php endforeach; ?>
      <button id="themeToggleDesktop" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;">🌙</button>
      <a href="<?php echo e($playStoreUrl); ?>" target="_blank" rel="noopener" class="shop-pill" style="background:linear-gradient(135deg,#22c55e,#14b8a6);">Get App</a>
      <a href="https://shop.ridefixer.app" target="_blank" rel="noopener" class="shop-pill">Shop</a>
    </nav>

    <div class="mobile-actions" style="display:none;align-items:center;gap:10px;">
      <button id="themeToggleMobile" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;">🌙</button>
      <button id="menuToggle" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;font-size:1rem;">☰</button>
    </div>
  </div>

  <aside id="mobileDrawer" style="position:fixed;top:0;right:-100%;width:min(320px,86vw);height:100vh;background:rgba(6,16,29,.98);backdrop-filter:blur(18px);z-index:100;border-left:1px solid rgba(255,255,255,.08);padding:26px 20px;transition:right .28s ease;display:flex;flex-direction:column;gap:14px;">
    <div style="display:flex;justify-content:space-between;align-items:center;">
      <strong>RideFixer</strong>
      <button id="menuClose" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;">✕</button>
    </div>
    <?php foreach ($navItems as $item): ?>
      <a class="<?php echo e(navActiveClass($item['href'], $currentPath)); ?>" href="<?php echo e($item['href']); ?>" style="padding:14px 16px;border-radius:14px;background:rgba(255,255,255,.04);font-weight:700;">
        <?php echo e($item['label']); ?>
      </a>
    <?php endforeach; ?>
  </aside>

  <div id="drawerOverlay" style="position:fixed;inset:0;background:rgba(0,0,0,.45);opacity:0;pointer-events:none;transition:.25s ease;z-index:90;"></div>
</header>
<script>
window.addEventListener('DOMContentLoaded', () => {
  const themeBtns = [document.getElementById('themeToggleDesktop'), document.getElementById('themeToggleMobile')].filter(Boolean);
  const menuBtn = document.getElementById('menuToggle');
  const closeBtn = document.getElementById('menuClose');
  const drawer = document.getElementById('mobileDrawer');
  const overlay = document.getElementById('drawerOverlay');

  const applyLabels = () => {
    const theme = document.documentElement.getAttribute('data-theme') || 'dark';
    themeBtns.forEach(btn => btn.textContent = theme === 'dark' ? '☀️' : '🌙');
  };

  themeBtns.forEach(btn => btn.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme') || 'dark';
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('ridefixer-theme', next);
    applyLabels();
  }));

  menuBtn?.addEventListener('click', () => {
    drawer.style.right = '0';
    overlay.style.opacity = '1';
    overlay.style.pointerEvents = 'auto';
  });

  const closeDrawer = () => {
    drawer.style.right = '-100%';
    overlay.style.opacity = '0';
    overlay.style.pointerEvents = 'none';
  };

  closeBtn?.addEventListener('click', closeDrawer);
  overlay?.addEventListener('click', closeDrawer);
  applyLabels();
});
</script>

<style>
@media (max-width: 980px) {
  .desktop-nav { display:none !important; }
  .mobile-actions { display:flex !important; }
}
@media (min-width: 981px) {
  .mobile-actions, #mobileDrawer, #drawerOverlay { display:none !important; }
}
</style>

<div class="wrap app-download-strip" style="margin-top:18px;">
<main class="wrap">
