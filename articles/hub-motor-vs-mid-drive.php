<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Hub Motor vs Mid Drive: What’s the Difference? | RideFixer';
$pageDescription = 'Compare hub motors and mid drive motors for e-bikes: torque, climbing, maintenance, efficiency, cost, and which one is better for commuting or hills.';
$canonical = $baseUrl . '/articles/hub-motor-vs-mid-drive';
require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Motor Guide</span>
  <h1 style="margin-top:14px;">Hub Motor vs Mid Drive: What’s the Difference?</h1>
  <p class="sub">Both power e-bikes, but they behave very differently in torque delivery, hill climbing, maintenance, drivetrain wear and efficiency.</p>
</section>

<section class="split">
  <article class="card">
    <h2>What is a Hub Motor?</h2>
    <p>A hub motor sits inside the front or rear wheel hub. It directly powers the wheel and is common on commuter and budget e-bikes.</p>

    <h2 style="margin-top:24px;">What is a Mid Drive Motor?</h2>
    <p>A mid drive motor sits near the crank and transfers power through the chain and drivetrain.</p>

    <h2 style="margin-top:24px;">Key Differences</h2>
    <ul>
      <li>Hub motors are simpler and often lower maintenance.</li>
      <li>Mid drives usually climb hills better.</li>
      <li>Mid drives use bike gears more efficiently.</li>
      <li>Hub motors are often cheaper.</li>
      <li>Mid drives can increase drivetrain wear.</li>
    </ul>

    <h2 style="margin-top:24px;">Which Is Better?</h2>
    <p>For flat commuting, many riders prefer hub motors. For steep hills, cargo loads or stronger climbing torque, mid drives are often better.</p>

    <h2 style="margin-top:24px;">Common Repair Concerns</h2>
    <ul>
      <li>Hub motor cable damage.</li>
      <li>Hall sensor faults.</li>
      <li>Controller communication issues.</li>
      <li>Chain and cassette wear on mid drives.</li>
    </ul>
  </article>

  <aside class="card">
    <h2 style="margin-top:0;">Related tools</h2>
    <div class="list">
      <a class="row" href="/motor-noise-diagnostic">Motor noise diagnostic</a>
      <a class="row" href="/error-codes">Error code database</a>
      <a class="row" href="/battery-health-calculator">Battery health calculator</a>
      <a class="row" href="/articles/cassette-vs-freewheel">Cassette vs freewheel</a>
    </div>
  </aside>
</section>

<?php require_once __DIR__ . '/../partials/footer.php'; ?>
