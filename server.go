package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	certPath := "./cert/server-cert-signed.pem"
	keyPath := "./cert/server-key.pem"
	clientCertPath := "./cert/ca-cert.pem"

	http.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
		io.WriteString(writer, "Hello, world!\n")
	})

	// Add CA cert to pool
	caCert, _ := ioutil.ReadFile(clientCertPath)
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// Create the TLS Config with the CA pool and enable Client certificate validation
	tlsConfig := &tls.Config{
		ClientCAs:  caCertPool,
		ClientAuth: tls.RequireAndVerifyClientCert,
	}

	server := &http.Server{
		Addr:      ":8080",
		TLSConfig: tlsConfig,
	}

	fmt.Printf("Server is started on port %s\n", server.Addr)
	if err := server.ListenAndServeTLS(certPath, keyPath); err != nil {
		log.Fatal(err)
	}
}
