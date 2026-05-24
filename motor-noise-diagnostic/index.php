<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Motor Noise Diagnostic - RideFixer';
$pageDescription = 'Compare authentic RideFixer e-bike repair sound samples for motor gears, derailleur adjustment, loose spokes and disc brake rubbing.';
$canonical = $baseUrl . '/motor-noise-diagnostic';

$noiseProfiles = [
  [
    'slug' => 'motor-gears-finish-noise',
    'title' => 'Motor Gear Finish / Grinding Noise',
    'type' => 'Motor / Gearbox',
    'severity' => 'High',
    'audio' => '/sounds/motor_gears_finish_noise.m4a',
    'symptoms' => ['Grinding or rough motor gear sound', 'Noise increases when the motor is under load', 'Motor feels less smooth than normal'],
    'causes' => ['Worn internal motor gears', 'Dry or damaged gearbox', 'Hub motor internal wear', 'Motor cover or bearing issue'],
    'fix' => ['Stop heavy riding until inspected', 'Check hub motor for play or roughness', 'Inspect internal nylon/planetary gears if serviceable', 'Replace worn gears or motor assembly if needed'],
  ],
  [
    'slug' => 'derailleur-adjustment-noise',
    'title' => 'Derailleur Adjustment Noise',
    'type' => 'Drivetrain',
    'severity' => 'Medium',
    'audio' => '/sounds/derailleur_adjustment_noise.m4a',
    'symptoms' => ['Clicking while pedalling', 'Chain jumps or rubs between gears', 'Noise changes when shifting'],
    'causes' => ['Derailleur indexing out of adjustment', 'Bent derailleur hanger', 'Cable tension incorrect', 'Worn chain or cassette'],
    'fix' => ['Re-index derailleur gears', 'Check hanger alignment', 'Adjust cable tension barrel adjuster', 'Inspect chain and cassette wear'],
  ],
  [
    'slug' => 'spoke-loose-noise',
    'title' => 'Loose Spoke Noise',
    'type' => 'Wheel',
    'severity' => 'Medium',
    'audio' => '/sounds/spoke_loose_noise.m4a',
    'symptoms' => ['Ping, creak or ticking from wheel', 'Noise appears under rider weight or acceleration', 'Wheel may feel slightly unstable'],
    'causes' => ['Loose spoke tension', 'Uneven wheel tension', 'Damaged spoke nipple', 'Rim stress around spoke holes'],
    'fix' => ['Check spoke tension by hand', 'True and tension the wheel', 'Replace damaged spoke/nipple', 'Avoid riding hard if several spokes are loose'],
  ],
  [
    'slug' => 'touching-disk-noise',
    'title' => 'Touching Disc / Rotor Rub Noise',
    'type' => 'Brake',
    'severity' => 'Low',
    'audio' => '/sounds/touching_disk_noise.m4a',
    'symptoms' => ['Scraping sound every wheel rotation', 'Noise while coasting', 'Disc rotor touches brake pad'],
    'causes' => ['Brake caliper not centered', 'Bent disc rotor', 'Wheel not seated correctly', 'Loose axle or hub play'],
    'fix' => ['Re-center brake caliper', 'Check rotor for wobble', 'Make sure wheel is seated correctly', 'True or replace bent rotor'],
  ],
];

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Authentic Sound Diagnostics</span>
  <h1 style="margin-top:14px;">Motor & Bike Noise Diagnostic</h1>
  <p class="sub">Compare your e-bike noise with real RideFixer sound samples collected from real repair cases and component issues.</p>
</section>

<section class="card">
  <h2>Real sound samples</h2>
  <div class="grid">
    <?php foreach ($noiseProfiles as $profile): ?>
      <article class="item sound-card">
        <div class="row-top">
          <span class="badge"><?php echo e($profile['type']); ?></span>
          <span class="badge <?php echo e(strtolower($profile['severity'])); ?>"><?php echo e($profile['severity']); ?></span>
        </div>
        <h3><?php echo e($profile['title']); ?></h3>
        <p><?php echo e($profile['symptoms'][0]); ?></p>

        <div style="margin-top:14px;">
          <audio controls preload="metadata" style="width:100%;">
            <source src="<?php echo e($profile['audio']); ?>" type="audio/mp4">
            <source src="<?php echo e($profile['audio']); ?>" type="audio/x-m4a">
            Your browser does not support audio playback.
          </audio>
        </div>

        <h4 style="margin:16px 0 6px;">Symptoms</h4>
        <ul>
          <?php foreach ($profile['symptoms'] as $symptom): ?>
            <li><?php echo e($symptom); ?></li>
          <?php endforeach; ?>
        </ul>

        <h4 style="margin:16px 0 6px;">Possible causes</h4>
        <ul>
          <?php foreach ($profile['causes'] as $cause): ?>
            <li><?php echo e($cause); ?></li>
          <?php endforeach; ?>
        </ul>

        <h4 style="margin:16px 0 6px;">Suggested fixes</h4>
        <ul>
          <?php foreach ($profile['fix'] as $fix): ?>
            <li><?php echo e($fix); ?></li>
          <?php endforeach; ?>
        </ul>
      </article>
    <?php endforeach; ?>
  </div>
</section>

<section class="split">
  <article class="card">
    <h2 style="margin-top:0;">Related diagnostic tools</h2>
    <div class="list">
      <a class="row" href="/error-codes/generic/e07">Hall sensor error diagnosis</a>
      <a class="row" href="/error-codes/generic/e29">Display/controller communication error</a>
      <a class="row" href="/settings/generic/p14">Controller current limit tuning</a>
      <a class="row" href="/scan">Scan display for controller errors</a>
      <a class="row" href="/battery-health-calculator">Battery health check</a>
    </div>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Built for real riders</h2>
    <p class="sub">Many e-bike problems are easier to recognise by sound than by text. These examples help riders compare issues before replacing parts or visiting a repair shop.</p>
    <div class="mini-grid">
      <div class="mini"><strong>4</strong><span>Real sound recordings</span></div>
      <div class="mini"><strong>RideFixer</strong><span>Practical repair guidance</span></div>
      <div class="mini"><strong>Authentic</strong><span>Real component issues</span></div>
    </div>
  </aside>
</section>

<?php require __DIR__ . '/../partials/footer.php';
