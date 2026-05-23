<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'RideFixer Articles & Guides';
$pageDescription = 'Browse RideFixer e-bike repair guides, battery tips, controller settings and troubleshooting articles.';
$canonical = $baseUrl . '/articles';
require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';

$articles = [
  ['url'=>'/articles/cassette-vs-freewheel','title'=>'Cassette vs Freewheel: What’s the Difference?','desc'=>'Understand how cassette and freewheel systems differ, which is stronger, and what is better for bikes and e-bikes.'],
  ['url'=>'/articles/battery-maintenance','title'=>'E‑Bike Battery Maintenance: Best Practices','desc'=>'Charging, storage, winter care and battery safety tips.'],
  ['url'=>'/error-codes/generic/e07','title'=>'Hall Sensor Fault Guide','desc'=>'Understand generic E07 hall sensor issues and fixes.'],
  ['url'=>'/error-codes/bafang/30','title'=>'Bafang Error 30 Explained','desc'=>'Display/controller communication troubleshooting guide.'],
  ['url'=>'/settings','title'=>'Chinese Display P-Settings Guide','desc'=>'SW900, S866 and generic controller settings help.'],
];
?>
<section class="card">
  <span class="eyebrow">Knowledge Base</span>
  <h1 style="margin-top:14px;">RideFixer Articles</h1>
  <p class="sub">Repair guides, battery knowledge, controller settings and troubleshooting resources built for e-bike riders and shops.</p>
</section>

<section class="card">
  <div class="grid">
    <?php foreach ($articles as $article): ?>
      <a class="item" href="<?php echo e($article['url']); ?>">
        <h3><?php echo e($article['title']); ?></h3>
        <p><?php echo e($article['desc']); ?></p>
      </a>
    <?php endforeach; ?>
  </div>
</section>

<?php require_once __DIR__ . '/../partials/footer.php'; ?>
