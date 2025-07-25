# wire-utility Helm Chart

Deploys a Wire Utility debug pod for troubleshooting MinIO, Cassandra, RabbitMQ, and Elasticsearch in Kubernetes.

## Quick Start

```sh
helm install wire-utility ./charts/wire-utility -f ./values/wire-server/values.yaml -f ./values/wire-server/secrets.yaml
kubectl exec -it wire-utility-0 -- bash
```

## Configuration

- Update service names and secrets in:
  - `values/wire-server/values.yaml`
  - `values/wire-server/secrets.yaml`
- Default settings are in `values.yaml`.
- All config values are set as environment variables in the pod.

**Service probing** runs every minute by default.  
To disable, set in `values.yaml`:
```yaml
probeThread:
  enabled: false
```

## Tools Available

- MinIO Client (`mc`)
- Cassandra Shell (`cqlsh`)
- RabbitMQ Admin (`rabbitmqadmin`)
- es-debug.py, curl, wget, nc, nslookup, dig, ping, traceroute, tcpdump, nmap, jq, python2/3, pip3, openssl, tree, file, less, vim/nano, find, grep/awk/sed

## Example Commands

```sh
mc ls wire-minio
cqlsh -e "DESCRIBE KEYSPACES;"
rabbitmqadmin list queues
```

## Troubleshooting

- Pod status: `kubectl get pods | grep wire-utility`
- Logs: `kubectl logs wire-utility-0`
- Connectivity: Use built-in tools

For reference values and secrets, see:
- [prod-values.example.yaml](https://github.com/wireapp/wire-server-deploy/blob/master/values/wire-server/prod-values.example.yaml)
- [prod-secrets.example.yaml](https://github.com/wireapp/wire-server-deploy/blob/master/values/wire-server/prod-secrets.example.yaml)