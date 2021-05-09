module github.com/jetstack/cert-manager-webhook-example

go 1.16

require (
	github.com/jetstack/cert-manager v1.3.1
	github.com/mhenderson-so/godnsmadeeasy v0.0.0-20161117210134-6c4a59b67887
	k8s.io/apiextensions-apiserver v0.19.0
	k8s.io/apimachinery v0.19.10
	k8s.io/client-go v0.19.10
)

//replace github.com/prometheus/client_golang => github.com/prometheus/client_golang v0.9.4
