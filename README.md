**1. Create CA Root**

```shell
openssl req -newkey rsa:2048 \
-new -nodes -x509 \
-days 365 \
-out ca.crt \
-keyout ca.key \
-subj "/C=SO/ST=Earth/L=Mountain/O=MegaEase/OU=MegaCloud/CN=localhost"
``` 

**2. Create Certification for server**
```shell
#create a key for server
openssl genrsa -out server.key 2048

#generate the Certificate Signing Request 
openssl req -new -key server.key -days 365 -out server.csr \
    -subj "/C=SO/ST=Earth/L=Mountain/O=MegaEase/OU=MegaCloud/CN=localhost" 

#sign it with Root CA
openssl x509  -req -in server.csr \
    -CA ca.crt \
    -CAkey ca.key  \
    -days 365 -sha256 -CAcreateserial \
    -addext "subjectAltName=DNS:example.com,DNS:www.example.com" 
    -out server.crt 
```