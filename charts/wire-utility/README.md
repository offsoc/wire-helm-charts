# wire-utility Helm Chart

This Helm chart deploys a Wire Utility debug pod on Kubernetes. It provides configurable parameters for connecting to MinIO, Cassandra, and RabbitMQ services.

## Usage

```sh
helm install wire-utility ./charts/wire-utility -f ./values/wire-server/values.yaml -f ./values/wire-server/secrets.yaml
```

## Prerequisites

Ensure the following values files exist the values directory in the wire-server-deploy artifacts with updated service names and secrets:

- `values/wire-server/values.yaml`
- `values/wire-server/secrets.yaml`

## Features

The debug pod comes with **preloaded tools** ready to use immediately:

- **MinIO Client (`mc`)**: Pre-configured with alias `wire-minio`
  ```sh
  # Try these commands for test only:
  mc ls wire-minio
  mc mb wire-minio/test-bucket
  mc cp file.txt wire-minio/bucket/
  ```

- **Cassandra Shell (`cqlsh`)**: Auto-configured connection settings
  ```sh
  # Try these commands:
  cqlsh
  cqlsh -e "DESCRIBE KEYSPACES;"
  cqlsh -e "SELECT * FROM system.local;"
  ```

- **RabbitMQ Admin (`rabbitmqadmin`)**: Pre-configured for management operations
  ```sh
  # Try these commands:
  rabbitmqadmin list queues
  rabbitmqadmin list exchanges
  rabbitmqadmin list users
  ```

## Getting Started

1. **Deploy the chart:**
   ```sh
   helm install wire-utility ./charts/wire-utility -f ./values/wire-server/valuers.yaml -f ./values/wire-server/secrets.yaml
   ```

2. **Access the debug pod:**
   ```sh
   kubectl exec -it wire-utility-0 -- bash
   ```

3. **Start using the tools immediately** - no additional setup required!

## Troubleshooting

- **Check pod status:** `kubectl get pods | grep wire-utility`
- **View pod logs:** `kubectl logs wire-utility-0`
- **Test connections:** Use the preloaded tools to verify connectivity

Refer to the values and secrets of the wire-server
- values.yaml
- https://github.com/wireapp/wire-server-deploy/blob/master/values/wire-server/prod-values.example.yaml
- https://github.com/wireapp/wire-server-deploy/blob/master/values/wire-server/prod-secrets.example.yaml