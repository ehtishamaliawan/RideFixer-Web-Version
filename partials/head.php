<?php
if (!isset($pageTitle)) $pageTitle = 'RideFixer';
if (!isset($pageDescription)) $pageDescription = 'RideFixer web app for e-bike diagnostics and maintenance.';
if (!isset($canonical)) $canonical = $baseUrl . '/';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><?php echo e($pageTitle); ?></title>
  <meta name="description" content="<?php echo e($pageDescription); ?>" />
  <meta name="keywords" content="RideFixer, e-bike error codes, e-bike settings, battery calculator, e-bike diagnostics" />
  <meta property="og:title" content="<?php echo e($pageTitle); ?>" />
  <meta property="og:description" content="<?php echo e($pageDescription); ?>" />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="<?php echo e($canonical); ?>" />
  <meta name="twitter:card" content="summary_large_image" />
  <link rel="canonical" href="<?php echo e($canonical); ?>" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@500;700;800&family=Manrope:wght@400;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="/assets/css/site.css" />
</head>
<body>
