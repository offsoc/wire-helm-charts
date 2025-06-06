# kube-prometheus-stack Helm Chart

This Helm chart deploys the kube-prometheus-stack, which provides monitoring for Kubernetes clusters using Prometheus as datasource for an external Grafana instance.

## custom values

Custom values are used to deploy the helm chart based on our need
- setups the the ingress for prometheus
- configuring the scraping targets for node-exporter
- Disabling grafana and alertmanager as we dont want them in the cluster unless we do it.
- Adding a secret manifest for prometheus basic-auth

Refer to the [values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml) for all configurable options.
