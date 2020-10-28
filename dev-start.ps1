Write-Host 'Starting dev deploy on Windows!'

docker-compose.exe up -d

terraform.exe init

Start-Sleep -Seconds 5.5

Write-Host $env:PUSERNAME
Write-Host $env:PPASSWORD

Write-Host 'Creating logistics database.'

terraform.exe apply -auto-approve `
  -var server=logisticscoresystemsdb `
  -var username=$env:PUSERNAME `
  -var password=$env:PPASSWORD `
  -var database=logistics
