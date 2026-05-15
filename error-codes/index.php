<?php
require __DIR__ . '/../lib/bootstrap.php';
$year = date("Y");

$selectedBrand = $_GET['brand'] ?? null;
$searchQuery = $_GET['search'] ?? null;
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error Code Search - RideFixer</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    html{scroll-behavior:smooth}
    body{
      font-family:Inter,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
      background:#06101d;
      color:#f8fbff;
      overflow-x:hidden;
    }
    a{text-decoration:none;color:inherit}
    .container{width:min(1180px,92%);margin:auto}

    :root{
      --cyan:#00d4ff;
      --teal:#22c7a9;
      --muted:#a9b8ca;
      --border:rgba(255,255,255,.13);
      --radius:26px;
    }

    header{
      position:sticky;top:0;z-index:20;
      background:rgba(6,16,29,.82);
      backdrop-filter:blur(18px);
      border-bottom:1px solid rgba(255,255,255,.08);
    }
    .nav{height:76px;display:flex;align-items:center;justify-content:space-between}
    .logo{display:flex;align-items:center;gap:12px;font-size:22px;font-weight:850}
    .logo-mark{width:44px;height:44px;border-radius:15px;display:grid;place-items:center;background:linear-gradient(135deg,var(--cyan),var(--teal));color:#00131a;font-weight:900}
    .nav-links{display:flex;gap:28px;color:var(--muted);font-size:14px}
    .nav-links a:hover{color:white}

    main{padding:60px 0}
    h1{font-size:2.5em;margin-bottom:30px;letter-spacing:-1px}
    .search-box{
      display:flex;
      gap:12px;
      margin-bottom:40px;
      flex-wrap:wrap;
    }
    input,select{
      padding:12px 18px;
      border-radius:12px;
      border:1px solid var(--border);
      background:rgba(255,255,255,.08);
      color:white;
      font-size:15px;
      flex:1;
      min-width:200px;
    }
    input::placeholder{color:var(--muted)}
    button{
      padding:12px 28px;
      background:linear-gradient(135deg,var(--cyan),var(--teal));
      color:#00131a;
      border:none;
      border-radius:12px;
      font-weight:700;
      cursor:pointer;
      transition:.25s;
      white-space:nowrap;
    }
    button:hover{transform:translateY(-2px)}

    .brands-grid{
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(140px,1fr));
      gap:12px;
      margin-bottom:40px;
    }
    .brand-btn{
      padding:15px 20px;
      border:2px solid var(--border);
      background:rgba(255,255,255,.05);
      border-radius:12px;
      color:white;
      font-weight:700;
      cursor:pointer;
      transition:.25s;
    }
    .brand-btn:hover{border-color:var(--cyan)}
    .brand-btn.active{border-color:var(--cyan);background:rgba(0,212,255,.1)}

    .results{
      display:grid;
      grid-template-columns:repeat(auto-fill,minmax(300px,1fr));
      gap:18px;
    }
    .error-card{
      background:linear-gradient(145deg,rgba(255,255,255,.09),rgba(255,255,255,.045));
      border:1px solid var(--border);
      border-radius:18px;
      padding:24px;
      cursor:pointer;
      transition:.25s;
    }
    .error-card:hover{
      transform:translateY(-4px);
      border-color:var(--cyan);
    }
    .error-card h3{font-size:20px;margin-bottom:8px}
    .error-code{
      color:var(--cyan);
      font-weight:700;
      font-size:18px;
      margin-bottom:12px;
    }
    .severity{
      display:inline-block;
      padding:4px 12px;
      border-radius:6px;
      font-size:12px;
      font-weight:700;
      margin-bottom:12px;
    }
    .severity.high{background:rgba(255,59,48,.2);color:#ff6b63}
    .severity.medium{background:rgba(255,193,7,.2);color:#ffb74d}
    .severity.info{background:rgba(33,150,243,.2);color:#64b5f6}
    .error-card p{color:var(--muted);font-size:14px;line-height:1.6}

    .modal{
      display:none;
      position:fixed;
      top:0;left:0;right:0;bottom:0;
      background:rgba(0,0,0,.8);
      z-index:100;
      align-items:center;
      justify-content:center;
      padding:20px;
      overflow-y:auto;
    }
    .modal.active{display:flex}
    .modal-content{
      background:#0b1b2f;
      border:1px solid var(--border);
      border-radius:24px;
      padding:40px;
      max-width:600px;
      margin:auto;
    }
    .close-btn{
      float:right;
      cursor:pointer;
      font-size:28px;
      color:var(--muted);
      margin-top:-10px;
    }
    .close-btn:hover{color:white}
    .modal h2{margin:20px 0 15px;color:var(--cyan)}
    .modal p{margin-bottom:15px;line-height:1.8}
    .modal ul{margin-left:20px;margin-bottom:15px}
    .modal li{margin-bottom:8px}

    footer{padding:38px 0;color:var(--muted);font-size:14px;border-top:1px solid rgba(255,255,255,.08)}
    .footer-inner{display:flex;justify-content:space-between;flex-wrap:wrap;gap:18px}

    @media(max-width:768px){
      h1{font-size:1.8em}
      .search-box{flex-direction:column}
      .search-box > *{min-width:100%}
      .brands-grid{grid-template-columns:repeat(auto-fit,minmax(100px,1fr))}
      .results{grid-template-columns:1fr}
      .modal-content{padding:24px;max-width:90%}
    }
  </style>
</head>

<body>

<header>
  <div class="container nav">
    <a class="logo" href="/">
      <span class="logo-mark">RF</span>
      <span>RideFixer</span>
    </a>
    <nav class="nav-links">
      <a href="/">Dashboard</a>
      <a href="/error-codes/">Error Codes</a>
      <a href="/battery-health-calculator/">Battery</a>
      <a href="/motor-noise-diagnostic/">Noise</a>
      <a href="/settings/">Settings</a>
    </nav>
  </div>
</header>

<main class="container">
  <h1>🔍 Error Code Search</h1>
  
  <div class="search-box">
    <input type="text" id="searchInput" placeholder="Search error code or description..." value="<?php echo htmlspecialchars($searchQuery ?? ''); ?>">
    <button onclick="searchErrors()">Search</button>
  </div>

  <h3 style="margin-bottom:20px;color:var(--muted)">Select a brand:</h3>
  <div class="brands-grid">
    <?php foreach ($brands as $slug => $name): ?>
      <button class="brand-btn <?php echo $selectedBrand === $slug ? 'active' : ''; ?>" onclick="filterByBrand('<?php echo $slug; ?>')">
        <?php echo $name; ?>
      </button>
    <?php endforeach; ?>
  </div>

  <div class="results" id="results">
    <?php
    $allCodes = [];
    
    if ($selectedBrand && isset($errorCatalog[$selectedBrand])) {
      $allCodes = $errorCatalog[$selectedBrand];
    } else if ($searchQuery) {
      $query = strtolower($searchQuery);
      foreach ($errorCatalog as $brand => $codes) {
        foreach ($codes as $code => $data) {
          if (strpos(strtolower($code), $query) !== false || 
              strpos(strtolower($data['title']), $query) !== false ||
              strpos(strtolower($data['description']), $query) !== false) {
            $allCodes[$code] = array_merge($data, ['_brand' => $brand]);
          }
        }
      }
    }

    if (empty($allCodes)):
    ?>
      <div style="grid-column:1/-1;text-align:center;padding:60px 20px">
        <p style="font-size:18px;color:var(--muted)">Select a brand or search to see error codes</p>
      </div>
    <?php else:
      foreach ($allCodes as $code => $data):
        $brand = $data['_brand'] ?? $selectedBrand;
        $severity = strtolower($data['severity']);
    ?>
      <div class="error-card" onclick="showErrorDetail('<?php echo htmlspecialchars(json_encode($data)); ?>', '<?php echo htmlspecialchars($code); ?>', '<?php echo htmlspecialchars($brands[$brand] ?? $brand); ?>')">
        <div class="error-code"><?php echo strtoupper($code); ?></div>
        <h3><?php echo htmlspecialchars($data['title']); ?></h3>
        <span class="severity <?php echo $severity; ?>"><?php echo ucfirst($severity); ?></span>
        <p><?php echo htmlspecialchars($data['description']); ?></p>
      </div>
    <?php
      endforeach;
    endif;
    ?>
  </div>
</main>

<div class="modal" id="modal">
  <div class="modal-content">
    <span class="close-btn" onclick="closeModal()">&times;</span>
    <div id="modalBody"></div>
  </div>
</div>

<footer>
  <div class="container footer-inner">
    <div>© <?php echo $year; ?> RideFixer. All rights reserved.</div>
    <div><a href="mailto:support@ridefixer.app">support@ridefixer.app</a></div>
  </div>
</footer>

<script>
function filterByBrand(brand) {
  window.location.href = '/error-codes/?brand=' + brand;
}

function searchErrors() {
  const query = document.getElementById('searchInput').value;
  if (query) {
    window.location.href = '/error-codes/?search=' + encodeURIComponent(query);
  }
}

function showErrorDetail(dataStr, code, brand) {
  const data = JSON.parse(dataStr);
  let html = `
    <h2>${data.title}</h2>
    <div style="margin-bottom:20px">
      <span style="color:var(--cyan);font-weight:700;font-size:16px">Code: ${code.toUpperCase()}</span>
      <span style="color:var(--muted);margin-left:20px">Brand: ${brand}</span>
    </div>

    <h3 style="margin-top:20px">📋 Description</h3>
    <p>${data.description}</p>

    <h3 style="margin-top:20px">🔍 What Happened</h3>
    <p>${data.what}</p>

    <h3 style="margin-top:20px">⚠️ Possible Causes</h3>
    <ul>
      ${data.causes.map(cause => `<li>${cause}</li>`).join('')}
    </ul>

    <h3 style="margin-top:20px">🚨 Symptoms</h3>
    <ul>
      ${data.symptoms.map(symptom => `<li>${symptom}</li>`).join('')}
    </ul>

    <h3 style="margin-top:20px">🛠️ How to Fix</h3>
    <ul>
      ${data.fix.map(step => `<li>${step}</li>`).join('')}
    </ul>

    <h3 style="margin-top:20px">🚴 Can You Ride?</h3>
    <p><strong>${data.rideability}</strong></p>

    <h3 style="margin-top:20px">⏰ How Urgent?</h3>
    <p><strong>${data.urgency}</strong></p>
  `;
  
  document.getElementById('modalBody').innerHTML = html;
  document.getElementById('modal').classList.add('active');
}

function closeModal() {
  document.getElementById('modal').classList.remove('active');
}

document.getElementById('searchInput').addEventListener('keypress', (e) => {
  if (e.key === 'Enter') searchErrors();
});
</script>

</body>
</html>
