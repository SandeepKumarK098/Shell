param (
    [Parameter(Mandatory = $true)]
    [string]$AutoTests_RootDir
)

$Azdo_Token = "4GSfcesV9qZSCsXaUX8RZrayPsiRwF5xRc1w6hgfBvRpNHoHjZ1MJQQJ99CBACAAAAAOHlUpAAASAZDO3gwS"

$AutoTests_Parent = $AutoTests_RootDir | Split-Path -Parent
$AutoTests_Child = $AutoTests_RootDir | Split-Path -Leaf

Write-Host "git init $AutoTests_Parent"
Write-Host "Sync following directories :"
Write-Host "  $AutoTests_Child/LV Automated Tests_New/Deployment/"
Write-Host "  $AutoTests_Child/LV Automated Tests_New/Framework Files/"
Write-Host "  $AutoTests_Child/LV Shared/Utilities/"
Write-Host "  $AutoTests_Child/LV Automated Tests_New/ExpressVIs/"
Write-Host "git reset --hard origin/master"
Write-Host "git clean -dfx"

if(!(Test-Path -Path "$AutoTests_Parent" )){
    New-Item -ItemType directory -Path "$AutoTests_Parent"
}

cd "$AutoTests_Parent"
git init "$AutoTests_Parent"
git sparse-checkout init
git config core.sparsecheckout true
Add-Content -Path ".git/info/sparse-checkout" "$AutoTests_Child/LV Automated Tests_New/Deployment/"
Add-Content -Path ".git/info/sparse-checkout" "$AutoTests_Child/LV Automated Tests_New/Framework Files/"
Add-Content -Path ".git/info/sparse-checkout" "$AutoTests_Child/LV Shared/Utilities/"
Add-Content -Path ".git/info/sparse-checkout" "$AutoTests_Child/LV Automated Tests_New/ExpressVIs/"
git remote add -f origin https://$Azdo_Token@ni.visualstudio.com/Users/_git/TestStand_migration
git reset --hard "origin/master"
git clean -dfx