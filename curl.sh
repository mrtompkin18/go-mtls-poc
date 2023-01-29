curl -v -k \
    --cert ./cert/client-cert-signed.pem \
    --key ./cert/client-key.pem \
    --cacert ./cert/ca-cert.pem \
    https://localhost:8080/hello