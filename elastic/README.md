### Create a k8s cluster for elastic

```
pks create-cluster observability -p privileged-small -e observability.k8s.pivotal.bosh.tokyo -n 3 --wait
pks get-credentials observability --sso-auto
```

### Install Elastic Stack


```
kubectl apply -f https://download.elastic.co/downloads/eck/1.0.0-beta1/all-in-one.yaml
```

https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-elasticsearch-specification.html

```
kubectl apply -f namespace.yml
kubectl apply -f elasticsearch.yml
```

https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-kibana.html


Password for ES/Kibana is below

```
kubectl get secret -n observability platform-log-es-elastic-user  -o go-template='{{.data.elastic | base64decode}}'
```

```
kubectl create -n observability configmap logstash-pipeline --from-file=pipeline -o yaml --dry-run | kubectl apply -f -
kubectl apply -f logstash.yml
```
