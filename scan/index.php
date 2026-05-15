<?php
$metaTitle = 'Scan Error Codes';
$metaDescription = 'Scan an image of your e-bike display to detect error codes using OCR.';
require_once __DIR__ . '/../partials/head.php';
require_once __DIR__ . '/../lib/bootstrap.php';
require_once __DIR__ . '/../partials/header.php';

// Flatten error catalog across brands
$flatCatalog = [];
foreach ($errorCatalog as $brand => $codes) {
    foreach ($codes as $code => $details) {
        $flatCatalog[$code] = $details;
    }
}
?>
<main class="wrap">
  <h1>Scan Error Codes</h1>
  <p>Upload a photo of your e-bike display showing the error code. Our OCR will detect the code and show you details.</p>
  <input type="file" id="imageInput" accept="image/*" />
  <div id="preview" style="margin-top:1rem;"></div>
  <button id="scanBtn" style="margin-top:1rem;padding:0.6rem 1.2rem;border:none;border-radius:4px;background:var(--teal);color:#fff;cursor:pointer;">Scan</button>
  <div id="result" style="margin-top:1.5rem;"></div>
</main>

<script src="https://cdn.jsdelivr.net/npm/tesseract.js@4.0.2/dist/tesseract.min.js"></script>
<script>
const errorCatalog = <?php echo json_encode($flatCatalog); ?>;
const imageInput = document.getElementById('imageInput');
const preview = document.getElementById('preview');
const resultDiv = document.getElementById('result');
let imageData = null;

imageInput.addEventListener('change', () => {
    const file = imageInput.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
        imageData = reader.result;
        preview.innerHTML = '<img src="' + imageData + '" style="max-width:100%;height:auto;border-radius:8px;">';
    };
    reader.readAsDataURL(file);
});

document.getElementById('scanBtn').addEventListener('click', () => {
    if (!imageData) {
        alert('Please select an image first.');
        return;
    }
    resultDiv.innerHTML = '<p>Scanning...</p>';
    Tesseract.recognize(
        imageData,
        'eng',
        { logger: m => console.log(m) }
    ).then(({ data: { text } }) => {
        const extracted = text.replace(/\s+/g, '').toUpperCase();
        let match = null;
        for (const code in errorCatalog) {
            if (extracted.includes(code.toUpperCase())) {
                match = Object.assign({ code: code }, errorCatalog[code]);
                break;
            }
        }
        if (match) {
            let html = '<h2>Error Code ' + match.code + '</h2>';
            if (match.severity) {
                html += '<p><strong>Severity:</strong> ' + match.severity + '</p>';
            }
            if (match.title) {
                html += '<p><strong>Title:</strong> ' + match.title + '</p>';
            }
            if (match.description) {
                html += '<p>' + match.description + '</p>';
            }
            if (match.fix) {
                html += '<p><strong>Possible Fixes:</strong> ' + match.fix.join(', ') + '</p>';
            }
            resultDiv.innerHTML = html;
        } else {
            resultDiv.innerHTML = '<p>No matching error code found. Please try again with a clearer image or ensure the code is visible.</p>';
        }
    }).catch(err => {
        console.error(err);
        resultDiv.innerHTML = '<p>Error scanning image.</p>';
    });
});
</script>

<?php require_once __DIR__ . '/../partials/footer.php'; ?>
