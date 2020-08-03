cd terraform

terraform apply -auto-approve \
    -var 'server=logisticsCoreSystemsDb' \
    -var 'pusername='$USERNAME'' \
    -var 'ppassword='$PASSWORD'' \
    -var 'database=logistics'