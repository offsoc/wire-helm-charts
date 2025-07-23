{{/* filepath: /Users/sukanta.ghosh/Workspace/helm-charts/charts/wire-utility/templates/utility-entrypoint-script.sh */}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "wire-utility.fullname" . }}-entrypoint
  labels:
    {{- include "wire-utility.labels" . | nindent 4 }}
data:
  entrypoint.sh: |
    #!/bin/bash
    set -e
    
    echo "🚀 Starting Wire utility debug pod..."
    echo ""
    
    # Function to check service connectivity
    check_service() {
      local service=$1
      local port=$2
      local name=$3
      if timeout 3 nc -z $service $port >/dev/null 2>&1; then
        echo "✅ $name ($service:$port)"
        return 0
      else
        echo "❌ $name ($service:$port)"
        return 1
      fi
    }
    
    # Extract MinIO host and port
    MINIO_HOST=$(echo ${MINIO_SERVICE_ENDPOINT} | sed 's|http[s]*://||' | cut -d':' -f1)
    MINIO_PORT=$(echo ${MINIO_SERVICE_ENDPOINT} | sed 's|http[s]*://||' | cut -d':' -f2)
    
    echo "=== Checking Service Connectivity ==="
    
    # Check all services
    check_service $MINIO_HOST $MINIO_PORT "MinIO"
    MINIO_STATUS=$?
    
    check_service ${CASSANDRA_SERVICE_NAME} ${CASSANDRA_SERVICE_PORT} "Cassandra"
    CASSANDRA_STATUS=$?
    
    check_service ${RABBITMQ_SERVICE_NAME} ${RABBITMQ_SERVICE_PORT} "RabbitMQ"
    RABBITMQ_STATUS=$?
    
    check_service ${ES_SERVICE_NAME} ${ES_PORT} "Elasticsearch"
    ES_STATUS=$?
    
    echo ""
    echo "=== Configuring Client Tools ==="
    
    # Configure MinIO client
    if [ $MINIO_STATUS -eq 0 ]; then
      mc alias set wire-minio ${MINIO_SERVICE_ENDPOINT} ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY} >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "✅ MinIO client configured"
      else
        echo "❌ MinIO client configuration failed"
      fi
    else
      echo "⚠️  MinIO unreachable - skipping configuration"
    fi
    
    # Configure Cassandra client
    mkdir -p /home/nonroot/.cassandra
    cat > /home/nonroot/.cassandra/cqlshrc << EOF
    [connection]
    hostname = ${CASSANDRA_SERVICE_NAME}
    port = ${CASSANDRA_SERVICE_PORT}
    EOF
    echo "✅ Cassandra client configured"
    
    # Configure RabbitMQ admin
    cat > /home/nonroot/.rabbitmqadmin.conf << EOF
    [default]
    hostname = ${RABBITMQ_SERVICE_NAME}
    port = ${RABBITMQ_MGMT_PORT}
    username = ${RABBITMQ_USERNAME}
    password = ${RABBITMQ_PASSWORD}
    EOF
    echo "✅ RabbitMQ admin configured"
    
    echo ""
    
    # Create simple status checker
    cat > /tmp/status.sh << 'EOFS'
    #!/bin/bash
    echo "=== Wire Utility Pod Status ==="
    echo "Pod: $(hostname)"
    echo "Time: $(date)"
    echo ""
    
    # Extract MinIO details
    MINIO_HOST=$(echo ${MINIO_SERVICE_ENDPOINT} | sed 's|http[s]*://||' | cut -d':' -f1)
    MINIO_PORT=$(echo ${MINIO_SERVICE_ENDPOINT} | sed 's|http[s]*://||' | cut -d':' -f2)
    
    echo "=== Service Status ==="
    timeout 2 nc -z $MINIO_HOST $MINIO_PORT >/dev/null 2>&1 && echo "✅ MinIO        $MINIO_HOST:$MINIO_PORT" || echo "❌ MinIO        $MINIO_HOST:$MINIO_PORT"
    timeout 2 nc -z ${CASSANDRA_SERVICE_NAME} ${CASSANDRA_SERVICE_PORT} >/dev/null 2>&1 && echo "✅ Cassandra    ${CASSANDRA_SERVICE_NAME}:${CASSANDRA_SERVICE_PORT}" || echo "❌ Cassandra    ${CASSANDRA_SERVICE_NAME}:${CASSANDRA_SERVICE_PORT}"
    timeout 2 nc -z ${RABBITMQ_SERVICE_NAME} ${RABBITMQ_SERVICE_PORT} >/dev/null 2>&1 && echo "✅ RabbitMQ     ${RABBITMQ_SERVICE_NAME}:${RABBITMQ_SERVICE_PORT}" || echo "❌ RabbitMQ     ${RABBITMQ_SERVICE_NAME}:${RABBITMQ_SERVICE_PORT}"
    timeout 2 nc -z ${ES_SERVICE_NAME} ${ES_PORT} >/dev/null 2>&1 && echo "✅ Elasticsearch ${ES_SERVICE_NAME}:${ES_PORT}" || echo "❌ Elasticsearch ${ES_SERVICE_NAME}:${ES_PORT}"
    
    echo ""
    echo "=== Quick Commands ==="
    echo "status                    # Show this status"
    echo "mc ls wire-minio          # List MinIO buckets"
    echo "cqlsh                     # Connect to Cassandra"
    echo "rabbitmqadmin list queues # List RabbitMQ queues"
    echo "es-debug.sh usages        # List available commands to run with es-debug.sh (e.g es-debug.sh health) to debug Elasticsearch"
    echo ""
    EOFS
    chmod +x /tmp/status.sh
    
    # Create welcome bashrc
    cat > /home/nonroot/.bashrc << 'EOF'
    # Source system bashrc
    [ -f /etc/bash.bashrc ] && source /etc/bash.bashrc
    
    # Custom prompt
    export PS1='\[\033[01;32m\]\u@wire-utility\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    
    # Useful aliases
    alias status='/tmp/status.sh'
    alias ll='ls -alF'
    alias la='ls -A'
    
    # Show welcome message on login
    echo ""
    echo "🔧 Welcome to Wire Utility Debug Pod"
    echo "📊 Type 'status' to check service connectivity"
    echo ""
    /tmp/status.sh
    EOF
    
    echo "=== Startup Complete ==="
    echo "✅ Wire utility debug pod ready!"
    echo "📝 Use: kubectl exec -it $(hostname) -- bash"
    echo ""
    
    # Keep container running
    tail -f /dev/null