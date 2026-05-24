<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'RideFixer Articles & Guides';
$pageDescription = 'Browse RideFixer e-bike repair guides, battery tips, controller settings and troubleshooting articles.';
$canonical = $baseUrl . '/articles';
require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';

$articles = [
  ['url'=>'/articles/hub-motor-vs-mid-drive','title'=>'Hub Motor vs Mid Drive: What’s the Difference?','desc'=>'Compare torque, climbing, maintenance, efficiency and which motor system is better for commuting or hills.'],
  ['url'=>'/articles/cassette-vs-freewheel','title'=>'Cassette vs Freewheel: What’s the Difference?','desc'=>'Understand how cassette and freewheel systems differ, which is stronger, and what is better for bikes and e-bikes.'],
  ['url'=>'/articles/battery-maintenance','title'=>'E‑Bike Battery Maintenance: Best Practices','desc'=>'Charging, storage, winter care and battery safety tips.'],
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
