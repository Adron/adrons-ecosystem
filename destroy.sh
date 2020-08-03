cd terraform

terraform destroy \
    -var 'server=logisticsCoreSystemsDb' \
    -var 'pusername='$USERNAME'' \
    -var 'ppassword='$PASSWORD'' \
    -var 'database=logistics'