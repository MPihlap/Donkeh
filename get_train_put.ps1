param (
    $ip="donkeh1.local",
    $tub_id,
    [switch]$force_all,
    [switch]$force_copy,
    [switch]$force_convert,
    [switch]$force_train
)

$ErrorActionPreference = "Stop" # Stop script if a single line fails

if (!(Test-Path "data/tub_$tub_id*") -or $force_all -or $force_copy) {
    scp -r ("pi@$ip"+":/home/pi/mycar/data/tub_$tub_id*") "data/"
}
else {
    Write-Host "Tub with id $tub_id already exists, skipping copy"
    Write-Host "Run with -force_all or -force_copy to override"
}

$tub_path = $(Get-ChildItem "data/tub_$tub_id*")[0]
$new_tub_path = $tub_path.FullName + "_v2"

if (!(Test-Path $new_tub_path) -or $force_all -or $force_convert) {
    python "$PSScriptRoot/../donkeycar/scripts/convert_to_tub_v2.py" --tub $tub_path --output $new_tub_path
}
else {
    Write-Host "Tub $new_tub_path already exists, skipping convert"
    Write-Host "Run with -force_all or -force_convert to override"
}

$model_path = "models/model_$tub_id.h5"

if (!(Test-Path $model_path) -or $force_all -or $force_train) {
    donkey train --tub $new_tub_path --model $model_path
}
else {
    Write-Host "Model $model_path already exists, skipping training"
    Write-Host "Run with -force_all or -force_train to override"
}

scp $model_path ("pi@$ip"+":/home/pi/mycar/models/")
