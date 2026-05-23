<?php
if (!isset($pageTitle)) $pageTitle = 'RideFixer';
if (!isset($pageDescription)) $pageDescription = 'RideFixer helps e-bike riders diagnose error codes, scan display faults, compare real repair sounds, check battery health and understand controller settings.';
if (!isset($canonical)) $canonical = $baseUrl . '/';
$appIcon = $baseUrl . '/my-android-app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png';
$ogImage = $appIcon;
$cssVersion = 'theme-v4';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><?php echo e($pageTitle); ?></title>
  <meta name="description" content="<?php echo e($pageDescription); ?>" />
  <meta name="theme-color" content="#06101d" />
  <link rel="canonical" href="<?php echo e($canonical); ?>" />
  <link rel="icon" href="<?php echo e($appIcon); ?>" type="image/png" />
  <link rel="apple-touch-icon" href="<?php echo e($appIcon); ?>" />
  <link rel="manifest" href="/manifest.webmanifest" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@500;700;800&family=Manrope:wght@400;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="/assets/css/site.css?v=<?php echo e($cssVersion); ?>" />
  <script>
    try {
      var saved = localStorage.getItem('ridefixer-theme');
      var hour = new Date().getHours();
      var autoTheme = (hour >= 7 && hour < 18) ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', saved || autoTheme);
    } catch (e) {
      document.documentElement.setAttribute('data-theme', 'dark');
    }
  </script>
</head>
<body>
