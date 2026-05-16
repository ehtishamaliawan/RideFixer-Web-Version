<?php
if (!isset($pageTitle)) $pageTitle = 'RideFixer';
if (!isset($pageDescription)) $pageDescription = 'RideFixer web app for e-bike diagnostics, error codes, Chinese display P-settings, battery health and maintenance.';
if (!isset($canonical)) $canonical = $baseUrl . '/';
$ogImage = $baseUrl . '/assets/img/ridefixer-og.png';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><?php echo e($pageTitle); ?></title>
  <meta name="description" content="<?php echo e($pageDescription); ?>" />
  <meta name="keywords" content="RideFixer, e-bike error codes, SW900 settings, S866 settings, KT LCD settings, Bafang error codes, Shimano STEPS error codes, Bosch e-bike error codes, e-bike battery calculator, e-bike diagnostics" />
  <meta name="robots" content="index,follow,max-image-preview:large" />
  <meta name="theme-color" content="#06101d" />
  <meta property="og:site_name" content="RideFixer" />
  <meta property="og:title" content="<?php echo e($pageTitle); ?>" />
  <meta property="og:description" content="<?php echo e($pageDescription); ?>" />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="<?php echo e($canonical); ?>" />
  <meta property="og:image" content="<?php echo e($ogImage); ?>" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="<?php echo e($pageTitle); ?>" />
  <meta name="twitter:description" content="<?php echo e($pageDescription); ?>" />
  <meta name="twitter:image" content="<?php echo e($ogImage); ?>" />
  <link rel="canonical" href="<?php echo e($canonical); ?>" />
  <link rel="manifest" href="/manifest.webmanifest" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@500;700;800&family=Manrope:wght@400;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="/assets/css/site.css" />
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "RideFixer",
    "url": "<?php echo e($baseUrl . '/'); ?>",
    "description": "RideFixer helps e-bike riders diagnose error codes, battery issues, motor noises and Chinese display P-settings.",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "<?php echo e($baseUrl); ?>/error-codes?search={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  }
  </script>
</head>
<body>
