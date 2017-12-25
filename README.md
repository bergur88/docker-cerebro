docker-cerebro
--------------

A Docker build for [Cerebro](https://github.com/lmenezes/cerebro), an Elasticsearch web admin tool.

Examples:

- default: `docker run --rm -p 9000:9000 dylanmei/cerebro`
- specify elasticsearch: `docker run --rm -p 9000:9000 dylanmei/cerebro bin/cerebro -Dhosts.0.host=http://server1:9200`
- specify config: `docker run --rm -p 9000:9000 -v $PWD/conf:/usr/cerebro/conf/application.conf dylanmei/cerebro`
- specify max heap: `docker run --rm -p -e ACTIVATOR_OPTS=-J-Xmx1024m" 9000:9000 dylanmei/cerebro`
