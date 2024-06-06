echo "${encrypted_password}" | base64 --decode | keybase pgp decrypt | xargs echo
