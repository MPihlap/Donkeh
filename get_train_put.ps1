param (
    $ip="donkeh1.local",
    $id,
    [switch]$force_all,
    [switch]$force_copy,
    [switch]$force_convert,
    [switch]$force_train
)
Write-Host "id=$id"
$ErrorActionPreference = "Stop" # Stop script if a single line fails

if (!(Test-Path "data/tub_$id*") -or $force_all -or $force_copy) {
    scp -r ("pi@$ip"+":/home/pi/mycar_new/data/*") "data/$id/"
}
else {
    Write-Host "Tub with id $id already exists, skipping copy"
    Write-Host "Run with -force_all or -force_copy to override `n"
}

$tub_path = "data/$id/"
#$tub_path = $(Get-ChildItem "data/tub_$id*")[0]
#$new_tub_path = $tub_path.FullName + "_v2"

#if (!(Test-Path $new_tub_path) -or $force_all -or $force_convert) {
#    python "$PSScriptRoot/../donkeycar/scripts/convert_to_tub_v2.py" --tub $tub_path --output $new_tub_path
#}
#else {
#    Write-Host "Tub $new_tub_path already exists, skipping convert"
#    Write-Host "Run with -force_all or -force_convert to override `n"
#}

$model_path = "models/model_$id.h5"

if (!(Test-Path $model_path) -or $force_all -or $force_train) {
    donkey train --tub $tub_path --model $model_path
}
else {
    Write-Host "Model $model_path already exists, skipping training"
    Write-Host "Run with -force_all or -force_train to override `n"
}

scp $model_path ("pi@$ip"+":/home/pi/mycar/models/")
