<?php
require __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Diagnostic Disclaimer - RideFixer';
$pageDescription = 'Important diagnostic and safety disclaimer for RideFixer users.';
$canonical = $baseUrl . '/legal/disclaimer';
require __DIR__ . '/../partials/head.php';
require __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">Important Safety Information</span>
  <h1 style="margin-top:14px;">RideFixer Diagnostic Disclaimer</h1>
  <p class="sub">RideFixer provides informational guidance only and should not replace professional inspection, manufacturer documentation or qualified repair advice.</p>
</section>

<section class="grid">
  <article class="item">
    <h3>Informational Guidance Only</h3>
    <p>RideFixer provides intelligent troubleshooting assistance, repair references and educational diagnostic information for e-bike riders and technicians.</p>
  </article>

  <article class="item">
    <h3>Not a Substitute for Professional Repair</h3>
    <p>Always consult a qualified technician for critical electrical, braking, battery or structural issues. Improper repairs may result in injury, damage or unsafe riding conditions.</p>
  </article>

  <article class="item">
    <h3>Controller & P-Setting Risks</h3>
    <p>Changing controller or display settings may affect speed limits, component lifespan, legality, motor heat and battery performance. Adjust settings responsibly.</p>
  </article>

  <article class="item">
    <h3>Battery & Electrical Safety</h3>
    <p>Lithium batteries can be dangerous if damaged or improperly handled. Stop using damaged batteries immediately and follow manufacturer safety procedures.</p>
  </article>

  <article class="item">
    <h3>AI-Assisted Recognition</h3>
    <p>RideFixer may use OCR, intelligent matching and automated recognition workflows. Suggested matches may not always be correct and should be verified manually.</p>
  </article>

  <article class="item">
    <h3>Limitation of Responsibility</h3>
    <p>RideFixer is not responsible for losses, injuries, damage, incorrect repairs or modifications resulting from the use of this platform or its diagnostic suggestions.</p>
  </article>
</section>
<?php require __DIR__ . '/../partials/footer.php'; ?>