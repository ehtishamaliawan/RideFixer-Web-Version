Set-Location "D:\Mobile Apps Projects\RideCare"
$outDir = "assets\sounds"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

function Write-Wav([string]$path, [double[]]$samples, [int]$sampleRate) {
  $channels = 1
  $bits = 16
  $blockAlign = [int]($channels * ($bits / 8))
  $byteRate = [int]($sampleRate * $blockAlign)
  $dataSize = [int]($samples.Length * 2)
  $riffSize = [int](36 + $dataSize)

  $fs = [System.IO.File]::Open($path, [System.IO.FileMode]::Create)
  $bw = New-Object System.IO.BinaryWriter($fs)
  $bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF'))
  $bw.Write($riffSize)
  $bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVE'))
  $bw.Write([System.Text.Encoding]::ASCII.GetBytes('fmt '))
  $bw.Write(16)
  $bw.Write([int16]1)
  $bw.Write([int16]$channels)
  $bw.Write($sampleRate)
  $bw.Write($byteRate)
  $bw.Write([int16]$blockAlign)
  $bw.Write([int16]$bits)
  $bw.Write([System.Text.Encoding]::ASCII.GetBytes('data'))
  $bw.Write($dataSize)

  foreach ($s in $samples) {
    $cl = [Math]::Max(-1.0, [Math]::Min(1.0, $s))
    $bw.Write([int16]($cl * 32767))
  }
  $bw.Close()
  $fs.Close()
}

function Make-Samples([double]$seconds, [scriptblock]$fn, [int]$sr) {
  $count = [int]($seconds * $sr)
  $arr = New-Object 'double[]' $count
  for ($i = 0; $i -lt $count; $i++) {
    $t = $i / $sr
    $arr[$i] = & $fn $t $i
  }
  return $arr
}

$sr = 22050

$s = Make-Samples 2.0 { param($t,$i) $period=0.18; $p=$t % $period; if ($p -lt 0.008) { [Math]::Sin(2*[Math]::PI*2500*$t)*0.75 } else { 0.0 } } $sr
Write-Wav (Join-Path $outDir 'clicking.wav') $s $sr

$s = Make-Samples 2.2 { param($t,$i) $noise=(Get-Random -Minimum -1.0 -Maximum 1.0); $grit=[Math]::Sin(2*[Math]::PI*120*$t)+0.4*[Math]::Sin(2*[Math]::PI*300*$t); (($noise*0.45)+($grit*0.25))*0.8 } $sr
Write-Wav (Join-Path $outDir 'grinding.wav') $s $sr

$s = Make-Samples 2.0 { param($t,$i) $f=130; (0.55*[Math]::Sin(2*[Math]::PI*$f*$t)+0.25*[Math]::Sin(2*[Math]::PI*($f*2)*$t))*(0.8+0.2*[Math]::Sin(2*[Math]::PI*2*$t)) } $sr
Write-Wav (Join-Path $outDir 'buzzing.wav') $s $sr

$s = Make-Samples 2.0 { param($t,$i) $f=700 + 400*$t; (0.55*[Math]::Sin(2*[Math]::PI*$f*$t)+0.15*[Math]::Sin(2*[Math]::PI*($f*2.6)*$t)) } $sr
Write-Wav (Join-Path $outDir 'whining.wav') $s $sr

$s = Make-Samples 2.2 { param($t,$i) $period=0.42; $p=$t % $period; if ($p -lt 0.06) { [Math]::Sin(2*[Math]::PI*70*$p)*[Math]::Exp(-25*$p)*0.95 } else { 0.0 } } $sr
Write-Wav (Join-Path $outDir 'clunking.wav') $s $sr

$s = Make-Samples 2.0 {
  param($t,$i)
  $noise = (Get-Random -Minimum -1.0 -Maximum 1.0)
  $gate = if ([Math]::Sin(2*[Math]::PI*18*$t) -gt 0) { 1.0 } else { 0.0 }
  ($noise * 0.55 * $gate) + (0.15 * [Math]::Sin(2*[Math]::PI*900*$t))
} $sr
Write-Wav (Join-Path $outDir 'rattling.wav') $s $sr

Get-ChildItem $outDir | Select-Object Name, Length
