# fluentd

[fluentd](https://www.fluentd.org) is an open source data collector, which lets you unify the data collection and consumption for a better use and understanding of data.



A kubernetes cluster centralized logging platform "-v /var/log/pods:/var/log/pods"

docker build --build-arg ALPINE_TAG=3.14.2 --build-arg BRANCH=v1.14.0 --build-arg RUBY_TAG=2.7.4-alpine3.14 --build-arg VERSION=1.14.0 --file Containerfile --no-cache --tag fluentd:dev .

## Container

The docker container consists of a single fluentd installation.  Multiple instance configurations are defined.

1. fluentd - a single consolidated log point.  An instance running this configuration is a single consolidation point for all log collectors.  This service accepts logs using the default fluentd forward directive.

2. fluentd-* - this is a log collector or endpoint.  A instance running one of these configurations is a log collector and should implent the forward directive to publish logs to the single consolidation point. 

## Kubernetes

The manifest configuration defined here is for a microk8s Kubernetes instance. The following is a synopsis of configured services.

### Namespace

This service is a part of the **logging** namesspace.

### Service

The service is a single instance serving ports for fluentd, unless otherwise noted in the fluentd-* documentation a log collector should not expose and access

1. 24224 - The default fluentd forward port
2. 80 - The default http endpoint

### Deployment

## To-Do List

X. Create a configmap to hold the configurations.
2. Filter in the fluentd (collector) where re-formating and mapping can occur
3. Test that this works dynamically (can load newly created log files) otherwise sighup the process and reload every 3 hours.
4. Save the postion files in a persistent storage.
