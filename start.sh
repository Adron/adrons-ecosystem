cd terraform

terraform apply -auto-approve \
    -var 'server=logisticscoresystemsdb' \
    -var 'username='$PUSERNAME'' \
    -var 'password='$PPASSWORD'' \
    -var 'database=logistics'