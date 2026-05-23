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

    <div style="display:flex;align-items:center;gap:10px;">
      <button id="themeToggle" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;">🌙</button>
      <button id="menuToggle" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;font-size:1rem;">☰</button>
    </div>

    <nav class="links desktop-nav" aria-label="Main navigation">
      <?php foreach ($navItems as $item): ?>
        <a class="<?php echo e(navActiveClass($item['href'], $currentPath)); ?>" href="<?php echo e($item['href']); ?>"><?php echo e($item['label']); ?></a>
      <?php endforeach; ?>
      <a href="<?php echo e($playStoreUrl); ?>" target="_blank" rel="noopener" class="shop-pill" style="background:linear-gradient(135deg,#22c55e,#14b8a6);">Get App</a>
      <a href="https://shop.ridefixer.app" target="_blank" rel="noopener" class="shop-pill">Shop</a>
    </nav>
  </div>

  <aside id="mobileDrawer" style="position:fixed;top:0;right:-100%;width:min(320px,86vw);height:100vh;background:rgba(6,16,29,.98);backdrop-filter:blur(18px);z-index:100;border-left:1px solid rgba(255,255,255,.08);padding:26px 20px;transition:right .28s ease;display:flex;flex-direction:column;gap:14px;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
      <strong style="font-size:1.1rem;">RideFixer</strong>
      <button id="menuClose" class="shop-pill" type="button" style="background:rgba(255,255,255,.08);color:inherit;">✕</button>
    </div>

    <?php foreach ($navItems as $item): ?>
      <a class="<?php echo e(navActiveClass($item['href'], $currentPath)); ?>" href="<?php echo e($item['href']); ?>" style="padding:14px 16px;border-radius:14px;background:rgba(255,255,255,.04);font-weight:700;">
        <?php echo e($item['label']); ?>
      </a>
    <?php endforeach; ?>

    <a href="<?php echo e($playStoreUrl); ?>" target="_blank" rel="noopener" class="btn btn-brand" style="margin-top:8px;">Download App</a>
    <a href="https://shop.ridefixer.app" target="_blank" rel="noopener" class="btn btn-ghost">Shop</a>
  </aside>

  <div id="drawerOverlay" style="position:fixed;inset:0;background:rgba(0,0,0,.45);opacity:0;pointer-events:none;transition:.25s ease;z-index:90;"></div>
</header>
<script>
window.addEventListener('DOMContentLoaded', () => {
  const btn = document.getElementById('themeToggle');
  const menuBtn = document.getElementById('menuToggle');
  const closeBtn = document.getElementById('menuClose');
  const drawer = document.getElementById('mobileDrawer');
  const overlay = document.getElementById('drawerOverlay');

  const applyLabel = () => {
    const theme = document.documentElement.getAttribute('data-theme') || 'dark';
    btn.textContent = theme === 'dark' ? '☀️' : '🌙';
  };

  btn?.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme') || 'dark';
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('ridefixer-theme', next);
    applyLabel();
  });

  const closeDrawer = () => {
    drawer.style.right = '-100%';
    overlay.style.opacity = '0';
    overlay.style.pointerEvents = 'none';
  };

  const openDrawer = () => {
    drawer.style.right = '0';
    overlay.style.opacity = '1';
    overlay.style.pointerEvents = 'auto';
  };

  menuBtn?.addEventListener('click', openDrawer);
  closeBtn?.addEventListener('click', closeDrawer);
  overlay?.addEventListener('click', closeDrawer);

  applyLabel();
});
</script>

<div class="wrap app-download-strip" style="margin-top:18px;">
  <div style="background:linear-gradient(135deg,rgba(34,197,94,.14),rgba(20,184,166,.12));border:1px solid rgba(255,255,255,.08);padding:14px 18px;border-radius:18px;display:flex;align-items:center;justify-content:space-between;gap:18px;flex-wrap:wrap;">
    <div style="display:flex;align-items:center;gap:14px;">
      <img src="<?php echo e($appIcon); ?>" alt="RideFixer app" style="width:54px;height:54px;border-radius:16px;" />
      <div>
        <strong style="display:block;font-size:1rem;">RideFixer Android App</strong>
        <span class="sub" style="font-size:.92rem;">Scan errors, compare sounds and diagnose e-bike issues on your phone.</span>
      </div>
    </div>
    <div style="display:flex;gap:12px;flex-wrap:wrap;">
      <a href="<?php echo e($playStoreUrl); ?>" target="_blank" rel="noopener" class="btn btn-brand">Download on Google Play</a>
    </div>
  </div>
</div>

<main class="wrap">
