# Helm Charts Repository

This repository contains a collection of Helm charts designed to simplify the deployment and management of Wire applications in the Kubernetes environment. Each chart is customizable and follows best practices to ensure reliability and scalability.

## Features

- Pre-configured templates for common resources.
- Easy customization using `values.yaml`.
- Support for a wide range of use cases and applications.
- Regular updates and maintenance.

## Usage

These charts are wrappers around the original upstream charts. The original charts are managed as dependencies in the `requirements.yaml` file with the appropriate upstream values, for example:

```yaml
dependencies:
  - name: <chart-name>
    version: <chart-version>
    repository: <chart-repository>
```

The charts from this repository are pulled by the [cailleach pipeline](https://github.com/zinfra/cailleach/blob/master/ci/pipelines/prod-ops/helm-charts-main.dhall) and manifested in 
the [wire-build's build.json file](https://github.com/wireapp/wire-builds/blob/dev/build.json). This `build.json` represents the list of all the wire charts which gets shipped together to the wire-could and air-gapped environments.

Check [the workflow diagram of the air-gapped environment](https://github.com/wireapp/wire-server-deploy/blob/master/offline/pull_helm_charts_flow.md)
