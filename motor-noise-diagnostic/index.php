<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Motor Noise Diagnostic - RideFixer';
$pageDescription = 'Compare authentic e-bike motor sound samples with likely repair causes and fixes.';
$canonical = $baseUrl . '/motor-noise-diagnostic';

$noiseProfiles = [
  [
    'slug' => 'grinding-under-load',
    'title' => 'Grinding Under Load',
    'type' => 'Mechanical',
    'severity' => 'High',
    'audio' => ['/sounds/grinding-under-load.mp3', '/sounds/grinding.mp3', '/sounds/motor-grinding.mp3', '/sounds/grinding_under_load.mp3'],
    'symptoms' => ['Grinding while accelerating', 'Noise increases on hills', 'Motor feels rough'],
    'causes' => ['Worn nylon gears', 'Damaged planetary gears', 'Low lubrication'],
    'fix' => ['Inspect internal gears', 'Regrease gearbox', 'Replace worn gears'],
  ],
  [
    'slug' => 'high-pitched-whine',
    'title' => 'High Pitched Whine',
    'type' => 'Electrical',
    'severity' => 'Medium',
    'audio' => ['/sounds/high-pitched-whine.mp3', '/sounds/whine.mp3', '/sounds/controller-whine.mp3', '/sounds/high_pitched_whine.mp3'],
    'symptoms' => ['Sharp electronic whine', 'Noise changes with assist level'],
    'causes' => ['PWM switching noise', 'Controller stress', 'Motor resonance'],
    'fix' => ['Reduce current limit', 'Inspect controller heat', 'Check motor alignment'],
  ],
  [
    'slug' => 'clicking-pedal-assist',
    'title' => 'Clicking During Pedal Assist',
    'type' => 'Sensor / Drivetrain',
    'severity' => 'Medium',
    'audio' => ['/sounds/clicking-pedal-assist.mp3', '/sounds/clicking.mp3', '/sounds/pedal-clicking.mp3', '/sounds/clicking_pedal_assist.mp3'],
    'symptoms' => ['Click every pedal rotation', 'Noise only with PAS active'],
    'causes' => ['Loose chainring', 'PAS sensor movement', 'Derailleur indexing'],
    'fix' => ['Tighten chainring', 'Check PAS ring', 'Adjust derailleur'],
  ],
  [
    'slug' => 'motor-judder',
    'title' => 'Motor Judder / Stutter',
    'type' => 'Hall Sensor',
    'severity' => 'High',
    'audio' => ['/sounds/motor-judder.mp3', '/sounds/judder.mp3', '/sounds/motor-stutter.mp3', '/sounds/motor_judder.mp3'],
    'symptoms' => ['Motor shakes', 'Wheel vibrates instead of spinning'],
    'causes' => ['Hall sensor fault', 'Phase wire issue', 'Controller timing problem'],
    'fix' => ['Inspect hall wiring', 'Check phase connectors', 'Test controller'],
  ],
  [
    'slug' => 'rotor-rub',
    'title' => 'Brake Rotor Rub',
    'type' => 'Brake',
    'severity' => 'Low',
    'audio' => ['/sounds/rotor-rub.mp3', '/sounds/brake-rotor-rub.mp3', '/sounds/disc-rub.mp3', '/sounds/rotor_rub.mp3'],
    'symptoms' => ['Scraping every wheel rotation', 'Noise while coasting'],
    'causes' => ['Bent rotor', 'Caliper misalignment', 'Loose axle'],
    'fix' => ['Center caliper', 'True rotor', 'Check wheel seating'],
  ],
  [
    'slug' => 'spoke-creak',
    'title' => 'Spoke Ping / Creak',
    'type' => 'Wheel',
    'severity' => 'Medium',
    'audio' => ['/sounds/spoke-creak.mp3', '/sounds/spoke-ping.mp3', '/sounds/wheel-creak.mp3', '/sounds/spoke_creak.mp3'],
    'symptoms' => ['Pinging while accelerating', 'Creak under load'],
    'causes' => ['Loose spokes', 'Uneven spoke tension', 'Cracked nipple seat'],
    'fix' => ['Tension wheel', 'Inspect rim holes', 'Replace damaged spokes'],
  ],
];

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Authentic Sound Diagnostics</span>
  <h1 style="margin-top:14px;">Motor Noise Diagnostic</h1>
  <p class="sub">Compare your e-bike sound with authentic files from RideFixer’s <code>/sounds</code> folder. No generated or fake audio is used.</p>
</section>

<section class="card">
  <h2>Common noise profiles</h2>
  <div class="grid">
    <?php foreach ($noiseProfiles as $profile): ?>
      <article class="item sound-card" data-audio='<?php echo e(json_encode($profile['audio'])); ?>'>
        <div class="row-top">
          <span class="badge"><?php echo e($profile['type']); ?></span>
          <span class="badge <?php echo e(strtolower($profile['severity'])); ?>"><?php echo e($profile['severity']); ?></span>
        </div>
        <h3><?php echo e($profile['title']); ?></h3>
        <p><?php echo e($profile['symptoms'][0]); ?></p>

        <div class="audio-slot" style="margin-top:14px;">
          <p class="sub">Checking authentic sound file...</p>
        </div>

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
      <a class="row" href="/settings/generic/p14">Controller current limit tuning</a>
      <a class="row" href="/scan">Scan display for controller errors</a>
      <a class="row" href="/battery-health-calculator">Battery health check</a>
    </div>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Audio policy</h2>
    <p class="sub">RideFixer now only uses real audio files from the repository. If a card says the sound file is missing, the filename needs to be matched to the real file in <code>/sounds</code>.</p>
    <div class="mini-grid">
      <div class="mini"><strong>Real</strong><span>No synthetic tones</span></div>
      <div class="mini"><strong>/sounds</strong><span>Repo audio source</span></div>
      <div class="mini"><strong>SEO</strong><span>Noise intent pages next</span></div>
    </div>
  </aside>
</section>

<script>
function testAudioPath(path) {
  return new Promise(resolve => {
    const audio = new Audio();
    audio.preload = 'metadata';
    audio.oncanplaythrough = () => resolve(path);
    audio.onerror = () => resolve(null);
    audio.src = path;
  });
}

async function findFirstAudio(paths) {
  for (const path of paths) {
    const ok = await testAudioPath(path);
    if (ok) return ok;
  }
  return null;
}

document.querySelectorAll('.sound-card').forEach(async card => {
  const slot = card.querySelector('.audio-slot');
  const paths = JSON.parse(card.dataset.audio || '[]');
  const audioPath = await findFirstAudio(paths);
  if (!audioPath) {
    slot.innerHTML = '<div class="row" style="box-shadow:none;"><strong>Authentic sound file not found</strong><p class="sub">Expected one of: ' + paths.map(p => p.replace('/sounds/', '')).join(', ') + '</p></div>';
    return;
  }
  slot.innerHTML = '<audio controls preload="metadata" style="width:100%;"><source src="' + audioPath + '" type="audio/mpeg">Your browser does not support audio playback.</audio><p class="sub">Source: ' + audioPath + '</p>';
});
</script>

<?php require __DIR__ . '/../partials/footer.php';
