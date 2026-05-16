<?php
if (!isset($pageTitle)) $pageTitle = 'RideFixer';
if (!isset($pageDescription)) $pageDescription = 'RideFixer helps e-bike riders diagnose error codes, scan display faults, compare real repair sounds, check battery health and understand controller settings.';
if (!isset($canonical)) $canonical = $baseUrl . '/';
$appIcon = $baseUrl . '/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png';
$ogImage = $appIcon;
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><?php echo e($pageTitle); ?></title>
  <meta name="description" content="<?php echo e($pageDescription); ?>" />
  <meta name="keywords" content="RideFixer, e-bike diagnostics, e-bike error codes, e-bike display errors, e-bike repair guide, SW900, S866, GD01, GD02, S830, KT LCD3, UKC1, Bafang error codes, Shimano STEPS error codes, Bosch e-bike error codes, e-bike battery health, motor noise diagnostic" />
  <meta name="robots" content="index,follow,max-image-preview:large" />
  <meta name="theme-color" content="#06101d" />
  <meta name="application-name" content="RideFixer" />
  <meta name="apple-mobile-web-app-title" content="RideFixer" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
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
  <link rel="icon" href="<?php echo e($appIcon); ?>" type="image/png" />
  <link rel="apple-touch-icon" href="<?php echo e($appIcon); ?>" />
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
    "description": "RideFixer helps e-bike riders diagnose error codes, display faults, battery issues, motor noises and controller settings.",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "<?php echo e($baseUrl); ?>/error-codes?search={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  }
  </script>
</head>
<body>
