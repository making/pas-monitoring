```
GRAFANA_VERSION=6.5.2
if [ ! -d grafana-${GRAFANA_VERSION} ];then
    wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
    tar xzf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz 
    rm -f grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz 
fi

sed -i '' -e 's|^http_port = 3000$|http_port = 8080|' grafana-${GRAFANA_VERSION}/conf/defaults.ini

PROMETHEUS_HOST=$(cf curl /v2/apps/$(cf app prometheus --guid)/stats | jq -r '.["0"].stats.uris[0]')
cat provisioning/datasources/datasources.yaml | sed -e "s|http://prometheus:9090|https://${PROMETHEUS_HOST}|g" > grafana-${GRAFANA_VERSION}/conf/provisioning/datasources/datasources.yaml

cp -r provisioning/dashboards/* grafana-${GRAFANA_VERSION}/conf/provisioning/dashboards/
sed -i '' -e 's|/etc/grafana/|/home/vcap/app/conf/|g' grafana-${GRAFANA_VERSION}/conf/provisioning/dashboards/dashboards.yaml

cf push grafana -m 128m -b binary_buildpack -p ./grafana-${GRAFANA_VERSION} --random-route -c "./bin/grafana-server -config=./conf/defaults.ini"
```
