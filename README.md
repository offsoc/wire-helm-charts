# Helm Charts Repository

This repository contains a collection of Helm charts designed to simplify the deployment and management of Wire applications in the kubernetes envrionment. Each chart is customizable and follows best practices to ensure reliability and scalability.

## Features

- Pre-configured templates for common resources.
- Easy customization using `values.yaml`.
- Support for a wide range of use cases and applications.
- Regular updates and maintenance.

## Usage

These charts are wrappers around the original upstream charts. The original charts are managed as dependencies in the `Chart.yaml` file with the appropriate upstream values, for example:

```yaml
dependencies:
  - name: <chart-name>
    version: <chart-version>
    repository: <chart-repository>
```

## Charts Managed by the Pipeline

- k8ssandra-operator
- keycloakx
- postgresql
- openbs
- smallstep-accomp
- step-certificates
- cert-manager

Once the charts are merged to the master branch, they are pulled by the [cailleach pipeline](https://github.com/zinfra/cailleach), which builds the chart manifest in a JSON file ([build.json](https://github.com/wireapp/wire-builds/blob/dev/build.json)) in the wire-build repository. All the charts in the `build.json` are pulled by the WSD pipeline, which includes dependencies, container images, and bundles them in the offline artifacts.