# wire-utility Helm Chart

This Helm chart deploys a Wire Utility debug pod on Kubernetes. It provides configurable parameters for connecting to MinIO, Cassandra, and RabbitMQ services.

## Usage

```sh
helm install wire-utility ./charts/wire-utility
```

## Configuration

Update parameters in `values.yaml` or override them via the command line.

### MinIO

Configure MinIO connection:

- **minio.serviceName**: MinIO service name
- **minio.port**: MinIO service port  
- **minio.secretName**: Secret containing MinIO credentials
- **minio.secretKeys.accessKey**: Key name for access key in secret
- **minio.secretKeys.secretKey**: Key name for secret key in secret

Example:

```sh
helm install wire-utility ./charts/wire-utility \
    --set minio.serviceName=minio-external \
    --set minio.port=9000
```

### Cassandra

Configure Cassandra connection:

- **cassandra.serviceName**: Cassandra service name
- **cassandra.port**: Cassandra service port

Example:

```sh
helm install wire-utility ./charts/wire-utility \
    --set cassandra.serviceName=cassandra-external \
    --set cassandra.port=9042
```

### RabbitMQ

Configure RabbitMQ connection:

- **rabbitmq.serviceName**: RabbitMQ service name
- **rabbitmq.port**: RabbitMQ service port
- **rabbitmq.secretName**: Secret containing RabbitMQ credentials
- **rabbitmq.secretKeys.username**: Key name for username in secret
- **rabbitmq.secretKeys.password**: Key name for password in secret

Example:

```sh
helm install wire-utility ./charts/wire-utility \
    --set rabbitmq.serviceName=rabbitmq-external \
    --set rabbitmq.port=5672
```

## Prerequisites

Ensure the following secrets exist in your cluster:

1. **MinIO Secret** (default: `cargohold`):
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: cargohold
   data:
     awsKeyId: <base64-encoded-access-key>
     awsSecretKey: <base64-encoded-secret-key>
   ```

2. **RabbitMQ Secret** (default: `background-worker`):
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: background-worker
   data:
     rabbitmqUsername: <base64-encoded-username>
     rabbitmqPassword: <base64-encoded-password>
   ```

## Features

The debug pod comes with **preloaded tools** ready to use immediately:

- **MinIO Client (`mc`)**: Pre-configured with alias `wire-minio`
  ```sh
  # Try these commands:
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
   helm install wire-utility ./charts/wire-utility
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

Refer to `values.yaml` for all configurable options.