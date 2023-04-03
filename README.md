# KindRed

A Kind cluster with its small fam of tools from the open source community, for POCs, testing, and whatever you want.

## Available tools

Here's the list of the services that are available in this repo:

- [Grafana](https://grafana.com/grafana/)
- [OpenTelemetry](https://opentelemetry.io/) (for logs and traces)
- [Loki](https://grafana.com/oss/loki/)
- [Tempo](https://grafana.com/oss/tempo/)
- [Envoy](https://www.envoyproxy.io/) (the configuration provided deploys a minimal API Gateway connected to an echo service)

Additionally, an echo service and a log generator will be deployed automatically at every start-up.

## Usage

### Init

The start-up script will create a Kind cluster named `kindred`, with three nodes. **Make sure you have Kind installed on your machine.**

To initialize the whole KindRed of services, run:

    ./start.sh -a

Otherwise, if you want to select only the services you need, run:

    ./start.sh

And follow the instructions prompted.

### Observability

If you include Grafana in the installation, you can access the UI to view logs from the Loki data source and build dashboards.

Simply expose the Grafana service port:

    kubectl port-forward -n grafana service/grafana 3000:80

Navigate to `localhost:3000`, and use the following credentials to log in Grafana as an administrator:

- username: `kindredadmin`
- password: `kindredpwd`

### Shutdown

To delete the cluster, simply run:

    kind delete cluster --name kindred
