FROM debian:jessie

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# JAVA
ENV JAVA_MAJOR_VERSION 8
ENV JAVA_UPDATE_VERSION 112
ENV JAVA_BUILD_NUMBER 15
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -sL --retry 3 \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/ \
 && grep '^networkaddress.cache.ttl=' $JAVA_HOME/jre/lib/security/java.security || echo 'networkaddress.cache.ttl=60' >> $JAVA_HOME/jre/lib/security/java.security \
 && ln -s $JAVA_HOME /usr/java \
 && rm -rf $JAVA_HOME/man

# SBT
ENV SBT_VERSION "0.13.5"
ENV SBT_HOME /usr/sbt
ENV PATH $PATH:$SBT_HOME/bin

RUN curl -sL --retry 3 "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" \
  | gunzip \
  | tar -x -C /usr/

EXPOSE 9000
WORKDIR /usr/cerebro

# CEREBRO
RUN git clone https://github.com/lmenezes/cerebro /usr/src/cerebro \
 && cd /usr/src/cerebro \
 && git checkout master \
 && sbt stage \
 && cp -r target/universal/stage/* /usr/cerebro/
 && rm -rf /usr/src/cerebro /root/.ivy2

CMD ["bin/cerebro", "-Dhosts.0.host=http://localhost:9200"]
