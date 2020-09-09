cd terraform

terraform destroy \
  -var 'server="logisticscoresystemsdb"' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database="logistics"' \
  -var 'apiport=8080'
