terraform destroy \
  -var 'server="logisticscoresystemsdb"' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database="logistics"'

docker-compose down