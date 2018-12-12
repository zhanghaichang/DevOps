#!/bin/sh
set-e-x

docker tag  gcr.io/istio-release/servicegraph:release-1.0-latest-daily  zhanghaichang/servicegraph:release-1.0-latest-daily
docker tag  gcr.io/istio-release/proxyv2:release-1.0-latest-daily zhanghaichang/proxyv2:release-1.0-latest-daily
docker tag  gcr.io/istio-release/pilot:release-1.0-latest-daily zhanghaichang/pilot:release-1.0-latest-daily
docker tag  gcr.io/istio-release/mixer:release-1.0-latest-daily zhanghaichang/mixer:release-1.0-latest-daily
docker tag  gcr.io/istio-release/galley:release-1.0-latest-daily zhanghaichang/galley:release-1.0-latest-daily
docker tag  gcr.io/istio-release/citadel:release-1.0-latest-daily zhanghaichang/citadel:release-1.0-latest-daily



docker push  zhanghaichang/servicegraph:release-1.0-latest-daily

docker push zhanghaichang/proxyv2:release-1.0-latest-daily

docker push zhanghaichang/pilot:release-1.0-latest-daily

docker push zhanghaichang/mixer:release-1.0-latest-daily

docker push zhanghaichang/galley:release-1.0-latest-daily

docker push zhanghaichang/citadel:release-1.0-latest-daily
