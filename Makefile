COMMON_NAME=my_cert

run:
	rm -rf ./cert/*.pem
	mkdir -p ./cert
	make create_ca
	make create_cert FOR=server
	make create_cert FOR=client

create_ca:
	openssl \
		req -new -x509 \
		-keyout cert/ca-key.pem \
		-out cert/ca-cert.pem \
		-days 365 \
		-subj "/CN=$(COMMON_NAME)" \
		-nodes

create_cert:
	make _create_key FOR=$(FOR)
	make _create_cert_sign_request FOR=$(FOR)
	make _sign_cert FOR=$(FOR)

_create_key:
	openssl genrsa \
		-out cert/$(FOR)-key.pem 4096

_create_cert_sign_request:
	openssl req -new \
		-key cert/$(FOR)-key.pem \
		-out cert/$(FOR)-csr.pem \
		-subj "/CN=$(COMMON_NAME)"

_sign_cert:
	openssl \
		x509 -req \
		-CA cert/ca-cert.pem \
		-CAkey cert/ca-key.pem \
		-in cert/$(FOR)-csr.pem \
		-out cert/$(FOR)-cert-signed.pem \
		-days 365 \
		-CAcreateserial \
		-extfile cert/config/cert.conf