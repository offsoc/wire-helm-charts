# kube-prometheus-stack Helm Chart

This Helm chart deploys the kube-prometheus-stack, which provides monitoring for Kubernetes clusters using Prometheus as datasource for an external Grafana instance.

## custom values

Custom values are used to deploy the helm chart based on our need
- setups the the ingress for prometheus
- configuring the scraping targets for node-exporter
- Disabling grafana and alertmanager as we dont want them in the cluster unless we do it.
- Adding a secret manifest for prometheus basic-auth

## Create and manage certificate with cert-managers ingress shim

Since we have cert-manager in the cluster, we will use annotation to create and manage certificate for prometheus ingress.
cert-manager's ingress shim will automatically create the certificate `(.tls.secretName)` based on the issuer in the ingress annotation `(cert-manager.io/issuer: letsencrypt-http01)`. If the issuer is not the cluster issuer then make sure the namespace scoped issuer is present in the namespace where this chart will be installed.

To know more about how ingress shim of the cert-manager works with annotated ingress, follow [the cert-manager document](https://cert-manager.io/docs/usage/ingress/)


Refer to the [values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml) for all configurable options.


## Versions

 **@version 0.1.0**
 * This version introduces ingress config with basic auth.
 * Creates PV and storageClass by default on kubenode3.
 * Pins prometheus POD on kubenode3 and uses the locally created storageClass
 * Mange basic auth secret through custom values file

 **@version 0.1.1**
 * Creates basic auth using helm helper function [htpasswd](https://masterminds.github.io/sprig/crypto.html#htpasswd)
 * Add helper NOTES

 **@version 0.1.2**
 * Scrape metrics by selecting all servicemonitors and podmonitors
 * Scrape metrics from all the namespaces
 * Prevents Helm from adding the default release label filter with `serviceMonitorSelectorNilUsesHelmValues: false`
 