> ⚠️  Prometheus deployed by the folloing steps is ephemeral. I recommend to use Prometheus on k8s or Prometheus BOSH Release.


```
PROMETHEUS_VERSION=2.15.1
if [ ! -d prometheus-${PROMETHEUS_VERSION}.linux-amd64 ];then
    wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
    tar xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
    rm -f prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
fi


om credentials -p cf -c .properties.metrics_agent_metrics_tls -f cert_pem > metrics.crt
om credentials -p cf -c .properties.metrics_agent_metrics_tls -f private_key_pem > metrics.key
om certificate-authorities -f json | jq -r '.[0].cert_pem' > metrics_ca.crt

cf create-space -o system monitoring-tools
cf target -o system -s monitoring-tools
cf push prometheus -k 2G -b binary_buildpack --random-route -c "./prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus --web.listen-address=:8080 --config.file=./prometheus.yml"
```
