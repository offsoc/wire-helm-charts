# migrate-features Helm Chart

`migrate-features` is a tool to migrate team features to a new data storage format. This tool is released as a Helm chart to include it in offline release artifacts.

This Helm chart deploys the `migrate-features` job to your Kubernetes cluster. See the details in the [release note](https://docs.wire.com/latest/changelog/changelog.html#release-notes_4) for this tool.

## Job Configuration

- To configure the job for your environment, update the values in `values.yaml`.
- If there is a new version of the image, update the `appVersion` value in `Chart.yaml`.
- If the Cassandra service is running in the `default` namespace, install the chart with the release name `default` as follows:

  ```sh
  helm install default ./charts/migrate-features
  ```



