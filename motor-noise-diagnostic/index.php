<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Motor Noise Diagnostic - RideFixer';
$pageDescription = 'Compare e-bike motor sounds, vibrations and clicking noises with likely repair causes and fixes.';
$canonical = $baseUrl . '/motor-noise-diagnostic';

$noiseProfiles = [
  [
    'slug' => 'grinding-under-load',
    'title' => 'Grinding Under Load',
    'type' => 'Mechanical',
    'severity' => 'High',
    'symptoms' => ['Grinding while accelerating', 'Noise increases on hills', 'Motor feels rough'],
    'causes' => ['Worn nylon gears', 'Damaged planetary gears', 'Low lubrication'],
    'fix' => ['Inspect internal gears', 'Regrease gearbox', 'Replace worn gears'],
  ],
  [
    'slug' => 'high-pitched-whine',
    'title' => 'High Pitched Whine',
    'type' => 'Electrical',
    'severity' => 'Medium',
    'symptoms' => ['Sharp electronic whine', 'Noise changes with assist level'],
    'causes' => ['PWM switching noise', 'Controller stress', 'Motor resonance'],
    'fix' => ['Reduce current limit', 'Inspect controller heat', 'Check motor alignment'],
  ],
  [
    'slug' => 'clicking-pedal-assist',
    'title' => 'Clicking During Pedal Assist',
    'type' => 'Sensor / Drivetrain',
    'severity' => 'Medium',
    'symptoms' => ['Click every pedal rotation', 'Noise only with PAS active'],
    'causes' => ['Loose chainring', 'PAS sensor movement', 'Derailleur indexing'],
    'fix' => ['Tighten chainring', 'Check PAS ring', 'Adjust derailleur'],
  ],
  [
    'slug' => 'motor-judder',
    'title' => 'Motor Judder / Stutter',
    'type' => 'Hall Sensor',
    'severity' => 'High',
    'symptoms' => ['Motor shakes', 'Wheel vibrates instead of spinning'],
    'causes' => ['Hall sensor fault', 'Phase wire issue', 'Controller timing problem'],
    'fix' => ['Inspect hall wiring', 'Check phase connectors', 'Test controller'],
  ],
  [
    'slug' => 'rotor-rub',
    'title' => 'Brake Rotor Rub',
    'type' => 'Brake',
    'severity' => 'Low',
    'symptoms' => ['Scraping every wheel rotation', 'Noise while coasting'],
    'causes' => ['Bent rotor', 'Caliper misalignment', 'Loose axle'],
    'fix' => ['Center caliper', 'True rotor', 'Check wheel seating'],
  ],
  [
    'slug' => 'spoke-creak',
    'title' => 'Spoke Ping / Creak',
    'type' => 'Wheel',
    'severity' => 'Medium',
    'symptoms' => ['Pinging while accelerating', 'Creak under load'],
    'causes' => ['Loose spokes', 'Uneven spoke tension', 'Cracked nipple seat'],
    'fix' => ['Tension wheel', 'Inspect rim holes', 'Replace damaged spokes'],
  ],
];

require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Interactive Sound Diagnostics</span>
  <h1 style="margin-top:14px;">Motor Noise Diagnostic</h1>
  <p class="sub">Compare your e-bike sound with common motor, controller, wheel and drivetrain issues. This area will evolve into a searchable audio diagnostic library.</p>
</section>

<section class="card">
  <h2>Common noise profiles</h2>
  <div class="grid">
    <?php foreach ($noiseProfiles as $profile): ?>
      <article class="item">
        <div class="row-top">
          <span class="badge"><?php echo e($profile['type']); ?></span>
          <span class="badge <?php echo e(strtolower($profile['severity'])); ?>"><?php echo e($profile['severity']); ?></span>
        </div>
        <h3><?php echo e($profile['title']); ?></h3>
        <p><?php echo e($profile['symptoms'][0]); ?></p>

        <div class="cta-row" style="margin-top:14px;">
          <button class="btn btn-brand play-tone" data-tone="<?php echo e($profile['slug']); ?>">▶ Play Sample</button>
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
    <h2 style="margin-top:0;">Future RideFixer audio system</h2>
    <p class="sub">The long-term goal is a real audio comparison system where riders upload motor sounds and RideFixer suggests likely causes using AI-assisted pattern matching.</p>
    <div class="mini-grid">
      <div class="mini"><strong>Hub Motors</strong><span>Geared & direct-drive</span></div>
      <div class="mini"><strong>Mid Drives</strong><span>Bosch, Shimano, Bafang</span></div>
      <div class="mini"><strong>Controllers</strong><span>Electrical noise patterns</span></div>
    </div>
  </aside>
</section>

<script>
const audioContext = new (window.AudioContext || window.webkitAudioContext)();

function playTone(type) {
  const oscillator = audioContext.createOscillator();
  const gain = audioContext.createGain();
  oscillator.connect(gain);
  gain.connect(audioContext.destination);

  let frequency = 240;
  let duration = 0.8;
  let waveform = 'sawtooth';

  if (type === 'high-pitched-whine') {
    frequency = 1200;
    waveform = 'triangle';
  } else if (type === 'clicking-pedal-assist') {
    frequency = 480;
    waveform = 'square';
  } else if (type === 'motor-judder') {
    frequency = 90;
    waveform = 'sawtooth';
  } else if (type === 'rotor-rub') {
    frequency = 350;
    waveform = 'triangle';
  } else if (type === 'spoke-creak') {
    frequency = 180;
    waveform = 'square';
  }

  oscillator.type = waveform;
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);
  gain.gain.setValueAtTime(0.001, audioContext.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.15, audioContext.currentTime + 0.05);
  gain.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + duration);

  oscillator.start();
  oscillator.stop(audioContext.currentTime + duration);
}

document.querySelectorAll('.play-tone').forEach(button => {
  button.addEventListener('click', () => playTone(button.dataset.tone));
});
</script>

<?php require __DIR__ . '/../partials/footer.php';
