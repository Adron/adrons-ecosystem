Write-Host 'Creating logistics database.'

terraform.exe destroy `
  -var server=logisticscoresystemsdb `
  -var username=$env:PUSERNAME `
  -var password=$env:PPASSWORD `
  -var database=logistics


docker-compose.exe down