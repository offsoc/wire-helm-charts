# PostgreSQL External Service Helm Chart

This Helm chart creates headless Kubernetes `Service`s with custom `Endpoint`s to connect to external PostgreSQL instances in an HA configuration (one primary and multiple replicas).

## Features

- Creates two separate services for read-write (primary) and read-only (replica) PostgreSQL connections
- Uses headless services for direct DNS resolution to PostgreSQL instances
- Supports different IP lists for read-write and read-only endpoints
- **Automated endpoint management** via CronJob that updates endpoint annotations with PostgreSQL topology information

## Components

### Services & Endpoints
- `postgresql-external-rw`: Read-write service pointing to primary PostgreSQL instance
- `postgresql-external-ro`: Read-only service pointing to replica PostgreSQL instances

### pg-endpoint-manager CronJob
- **Purpose**: Automatically updates endpoint annotations with PostgreSQL cluster topology
- **Source**: [https://github.com/wireapp/postgres-endpoint-manager](https://github.com/wireapp/postgres-endpoint-manager)
- **Schedule**: Runs every 2 minutes (configurable)
- **Annotations Updated**:
  - `postgres.discovery/last-topology`: Current primary and standby server IPs
  - `postgres.discovery/last-update`: Timestamp of last topology check
- **RBAC**: Uses dedicated ServiceAccount with minimal permissions to update only PostgreSQL endpoints

## Configuration

Configure the chart in your `values.yaml`:

```yaml
portPostgresql: 5432  # PostgreSQL port number

# List of IP addresses for read-write (primary) PostgreSQL instance
RWIPs:
  - <primary-ip>

# List of IP addresses for read-only (replica) PostgreSQL instances
ROIPs:
  - <replica-ip-1>
  - <replica-ip-2>

# CronJob configuration (optional)
cronJob:
  schedule: "*/2 * * * *"  # Every 2 minutes
  image:
    repository: quay.io/wire/postgres-endpoint-manager
    tag: "1.0.0"
```

## Usage

```bash
# Install the chart
helm install postgresql-external ./charts/postgresql-external -f values.yaml

# Check endpoint annotations
kubectl get endpoints postgresql-external-rw -o yaml | grep "postgres.discovery"
kubectl get endpoints postgresql-external-ro -o yaml | grep "postgres.discovery"

# Monitor CronJob
kubectl get cronjobs
kubectl logs -l job-name=postgres-endpoint-manager
```

## Example Output

The CronJob will add these annotations to your endpoints:

```yaml
metadata:
  annotations:
    postgres.discovery/last-topology: "primary:192.168.1.10;standbys:192.168.1.11,192.168.1.12"
    postgres.discovery/last-update: "2025-09-01T08:34:51+00:00"
```

