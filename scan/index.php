<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'Scan E-Bike Error Codes - RideFixer';
$pageDescription = 'Upload a photo of your e-bike display and scan it for possible error codes using browser OCR.';
$canonical = $baseUrl . '/scan';

$flatCatalog = [];
foreach ($errorCatalog as $brand => $codes) {
  foreach ($codes as $code => $details) {
    $flatCatalog[] = [
      'brand' => $brand,
      'brandName' => $brands[$brand] ?? ucfirst($brand),
      'code' => $code,
      'url' => '/error-codes/' . $brand . '/' . $code,
      'title' => $details['title'],
      'severity' => $details['severity'],
      'description' => $details['description'],
      'fix' => $details['fix'] ?? [],
    ];
  }
}

require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">OCR Display Scanner</span>
  <h1 style="margin-top:14px;">Scan E-Bike Error Codes</h1>
  <p class="sub">Upload a clear photo of your display. RideFixer will read the text in your browser and match possible codes from the diagnostic database.</p>

  <div class="split" style="margin-top:18px;">
    <div class="item" style="display:grid;gap:12px;">
      <h3 style="margin:0;">1. Upload display photo</h3>
      <input type="file" id="imageInput" accept="image/*" />
      <div id="preview" class="item" style="min-height:180px;display:grid;place-items:center;box-shadow:none;">
        <p class="sub">Preview will appear here.</p>
      </div>
      <button id="scanBtn" class="btn btn-brand" type="button">📷 Scan Image</button>
      <p class="sub" style="font-size:.9rem;margin:0;">Tip: crop close to the display and make sure the error code is visible.</p>
    </div>

    <div class="item" style="display:grid;gap:12px;">
      <h3 style="margin:0;">2. Or search manually</h3>
      <label for="manualCode">Code, symptom or keyword</label>
      <input id="manualCode" placeholder="e07, hall sensor, throttle, 503..." />
      <button id="manualBtn" class="btn btn-dark" type="button">Search database</button>
      <div id="ocrText" class="sub"></div>
      <div id="result"></div>
    </div>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js"></script>
<script>
const catalog = <?php echo json_encode($flatCatalog, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); ?>;
const imageInput = document.getElementById('imageInput');
const preview = document.getElementById('preview');
const resultDiv = document.getElementById('result');
const ocrText = document.getElementById('ocrText');
let imageData = null;

function escapeHtml(value) {
  return String(value).replace(/[&<>'"]/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[char]));
}

function normalise(value) {
  return String(value || '').toLowerCase().replace(/[^a-z0-9]/g, '');
}

function findMatches(text) {
  const compact = normalise(text);
  const loose = String(text || '').toLowerCase();
  return catalog.filter(item => {
    const code = normalise(item.code);
    const title = normalise(item.title);
    const description = normalise(item.description);
    const brand = normalise(item.brandName);
    return compact.includes(code) || compact.includes(title) || compact.includes(description) || compact.includes(brand) || loose.includes(String(item.code).toLowerCase());
  }).slice(0, 8);
}

function renderMatches(matches, sourceText = '') {
  if (!matches.length) {
    resultDiv.innerHTML = '<div class="row"><strong>No exact match found</strong><p class="sub">Try a clearer image or search manually by code, brand, or symptom.</p><a class="btn btn-brand" href="/error-codes">Open full error-code database</a></div>';
    return;
  }
  resultDiv.innerHTML = '<div class="list">' + matches.map(item => `
    <a class="row" href="${item.url}">
      <div class="row-top"><span class="code">${escapeHtml(item.code.toUpperCase())}</span><span class="badge ${escapeHtml(item.severity.toLowerCase())}">${escapeHtml(item.severity)}</span></div>
      <h3>${escapeHtml(item.title)}</h3>
      <p class="sub">${escapeHtml(item.brandName)} · ${escapeHtml(item.description)}</p>
    </a>
  `).join('') + '</div>';
  if (sourceText) ocrText.textContent = 'Detected text: ' + sourceText.trim().slice(0, 220);
}

imageInput.addEventListener('change', () => {
  const file = imageInput.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = () => {
    imageData = reader.result;
    preview.innerHTML = '<img src="' + imageData + '" alt="Uploaded e-bike display preview" style="max-height:360px;border-radius:18px;object-fit:contain;">';
  };
  reader.readAsDataURL(file);
});

document.getElementById('scanBtn').addEventListener('click', async () => {
  if (!imageData) {
    resultDiv.innerHTML = '<div class="row"><strong>Please select an image first.</strong></div>';
    return;
  }
  resultDiv.innerHTML = '<div class="row"><strong>Scanning image...</strong><p class="sub">OCR runs in your browser. This may take a few seconds.</p></div>';
  ocrText.textContent = '';
  try {
    const response = await Tesseract.recognize(imageData, 'eng');
    const text = response.data.text || '';
    renderMatches(findMatches(text), text);
  } catch (err) {
    console.error(err);
    resultDiv.innerHTML = '<div class="row"><strong>OCR failed.</strong><p class="sub">Please try manual search or upload a clearer image.</p></div>';
  }
});

document.getElementById('manualBtn').addEventListener('click', () => {
  const value = document.getElementById('manualCode').value;
  renderMatches(findMatches(value), '');
});

document.getElementById('manualCode').addEventListener('keydown', event => {
  if (event.key === 'Enter') document.getElementById('manualBtn').click();
});
</script>
<?php require_once __DIR__ . '/../partials/footer.php'; ?>
