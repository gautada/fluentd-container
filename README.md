# fluentd

[fluentd](https://www.fluentd.org) is an open source data collector, which lets you unify the data collection and consumption for a better use and understanding of data.

## Development

for development in a local container manager set two environment variables.  `COMPOSE_FLUENTD_CONFIG` is a path to the configfile to use.  `COMPOSE_FLUENTD_OPTIONS` provide CLI parameters to the fluentd script. For debugging **fluentd** use `-vv`. These variables map to `FLUENTD_CONFIG` and `FLUENTD_OPTIONS` environment variables in production deployments.

## Production

### Environment Variables

Set the variable `FLUENTD_CONFIG` to the configfile to use and generally `FLUENTD_OPTIONS` can be ignored.

### Volumes

The container is designed to monitor the **node** logs in a **kubernetes** cluster.  As such the **node** log folders must be mounted to the **pod** and configured in the `FLUENTD_CONFIG` file.


if grep -Fxq "$FILENAME" my_list.txt
then
	# code if found
else
	# code if not found
fi

https://stackoverflow.com/questions/62277217/how-can-i-use-environment-variables-in-fluentd-config

https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/




^(?<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+-\d{2}:\d{2})\s+(?<level>\w+)\s+(?<source>\w+)\s+\[(?<message>\w+)\]\s+(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(?<port>\d+)\s+-\s+(?<pid>\d+)\s+"(?<query>[^"]+)"\s+(?<query_type>\w+)\s+(?<response_type>\w+)\s+(?<response_code>\d+)\s+(?<response_time>\d+\.\d+[a-z]+)\s*$