<?php
require_once __DIR__ . '/../lib/bootstrap.php';
$pageTitle = 'AI-Assisted E-Bike Display Scan - RideFixer';
$pageDescription = 'Upload a photo of your e-bike display and let RideFixer intelligently match display models and possible error codes.';
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
    ];
  }
}

$displayModels = [];
foreach ($displayCatalog as $slug => $display) {
  $displayModels[] = [
    'id' => $slug,
    'name' => $display['name'],
    'family' => $display['family'],
    'errorUrl' => '/displays/' . $slug . '/error-codes',
  ];
}

require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../partials/header.php';
?>
<section class="card">
  <span class="eyebrow">AI-Assisted Display Scan</span>
  <h1 style="margin-top:14px;">Scan E-Bike Display</h1>
  <p class="sub">Upload a clear photo of your display. RideFixer intelligently matches display models and possible error codes.</p>

  <div class="split" style="margin-top:18px;">
    <div class="item" style="display:grid;gap:12px;">
      <h3 style="margin:0;">1. Upload display photo</h3>
      <input type="file" id="imageInput" accept="image/*" />
      <div id="preview" class="item" style="min-height:180px;display:grid;place-items:center;box-shadow:none;">
        <p class="sub">Preview will appear here.</p>
      </div>
      <button id="scanBtn" class="btn btn-brand" type="button">📷 Scan Image</button>
    </div>

    <div class="item" style="display:grid;gap:12px;">
      <h3 style="margin:0;">2. Search manually</h3>
      <input id="manualCode" placeholder="SW900, S866, E07, hall sensor..." />
      <button id="manualBtn" class="btn btn-dark" type="button">Search database</button>
      <div id="ocrText" class="sub"></div>
      <div id="result"></div>
    </div>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js"></script>
<script>
const catalog = <?php echo json_encode($flatCatalog, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); ?>;
const displayModels = <?php echo json_encode($displayModels, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); ?>;
const imageInput = document.getElementById('imageInput');
const preview = document.getElementById('preview');
const resultDiv = document.getElementById('result');
const ocrText = document.getElementById('ocrText');
let imageData = null;

function dense(value) {
  return String(value || '').toUpperCase().replace(/[^A-Z0-9]/g, '');
}

function denseAlt(value) {
  return dense(value).replace(/O/g, '0').replace(/I/g, '1').replace(/L/g, '1').replace(/S/g, '5');
}

function scoreText(text, variant) {
  const d = dense(text);
  const a = denseAlt(text);
  const v = dense(variant);
  if (d.includes(v)) return v.length * 12;
  if (a.includes(denseAlt(v))) return v.length * 9;
  return 0;
}

function rankModels(text) {
  return displayModels.map(model => {
    const score = Math.max(scoreText(text, model.id), scoreText(text, model.name));
    return {...model, score};
  }).filter(x => x.score > 0).sort((a,b) => b.score - a.score).slice(0,5);
}

function rankCodes(text) {
  return catalog.map(item => {
    const score = Math.max(scoreText(text, item.code), scoreText(text, item.title));
    return {...item, score};
  }).filter(x => x.score > 0).sort((a,b) => b.score - a.score).slice(0,8);
}

function render(modelMatches, codeMatches, raw='') {
  let html = '<div class="list">';

  if (modelMatches.length) {
    html += '<div class="row"><strong>Likely display models</strong></div>';
    html += modelMatches.map(model => `
      <a class="row" href="${model.errorUrl}">
        <div class="row-top"><span class="code">${model.name}</span><span class="badge low">${Math.min(99, model.score)}%</span></div>
        <p class="sub">Open model-specific diagnostics</p>
      </a>
    `).join('');
  }

  if (codeMatches.length) {
    html += '<div class="row"><strong>Possible error codes</strong></div>';
    html += codeMatches.map(item => `
      <a class="row" href="${item.url}">
        <div class="row-top"><span class="code">${item.code.toUpperCase()}</span><span class="badge ${item.severity.toLowerCase()}">${item.severity}</span></div>
        <h3>${item.title}</h3>
        <p class="sub">${item.brandName} · ${item.description}</p>
      </a>
    `).join('');
  }

  if (!modelMatches.length && !codeMatches.length) {
    html += '<div class="row"><strong>No strong match found</strong><p class="sub">Try a clearer image or manual search.</p></div>';
  }

  html += '</div>';
  resultDiv.innerHTML = html;
  if (raw) ocrText.textContent = 'Detected text: ' + raw.slice(0, 240);
}

imageInput.addEventListener('change', () => {
  const file = imageInput.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = () => {
    imageData = reader.result;
    preview.innerHTML = '<img src="' + imageData + '" style="max-height:360px;border-radius:18px;object-fit:contain;">';
  };
  reader.readAsDataURL(file);
});

document.getElementById('scanBtn').addEventListener('click', async () => {
  if (!imageData) return;

  resultDiv.innerHTML = '<div class="row"><strong>Scanning image...</strong></div>';

  try {
    const response = await Tesseract.recognize(imageData, 'eng');
    const text = response.data.text || '';
    render(rankModels(text), rankCodes(text), text);
  } catch (err) {
    resultDiv.innerHTML = '<div class="row"><strong>Scan failed</strong></div>';
  }
});

document.getElementById('manualBtn').addEventListener('click', () => {
  const value = document.getElementById('manualCode').value;
  render(rankModels(value), rankCodes(value));
});
</script>
<?php require_once __DIR__ . '/../partials/footer.php'; ?>
