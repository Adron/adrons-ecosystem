docker-compose up -d

terraform init

sleep 1

terraform apply -auto-approve \
  -var 'server=logisticscoresystemsdb' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database=logistics'
