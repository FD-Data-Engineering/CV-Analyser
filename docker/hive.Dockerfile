FROM jpacerqueira83/hadoop-k8s:3.2.1

# Variables that define which software versions to install.
ARG HIVE_VERSION=3.1.2
ENV JAVA_HOME=/usr/local/openjdk-8

# Download and install the standalone metastore binary.
RUN curl https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/apache-hive-${HIVE_VERSION}-bin /opt/hive

# Remove old guava jar to avoid comflict with Hadoop
RUN rm /opt/hive/lib/guava-*.jar && \
	ln -s /opt/hadoop/share/hadoop/common/lib/guava-*.jar /opt/hive/lib

# Download and install the postgresql connector.
RUN curl -L https://jdbc.postgresql.org/download/postgresql-42.2.10.jar -O \
	&& mv postgresql-42.2.10.jar /opt/hive/lib/

# Add metastore script
COPY start-metastore.sh /opt/hive/bin

# Add 'hive' user so that this cluster is not run as root.
RUN groupadd -g 1020 hive && \
    useradd -r -m -u 1020 -g hadoop hive && \
    chown -R -L hive /opt/hive && \
    chgrp -R -L hadoop /opt/hive && \
    mkdir -p /var/log/hive && \
    chown -R -L hive /var/log/hive && \
    chgrp -R -L hadoop /var/log/hive && \
    mkdir -p /var/run/hive && \
    chown -R -L hive /var/run/hive && \
    chgrp -R -L hadoop /var/run/hive

USER hive
WORKDIR /home/hive

# Set necessary environment variables. 
ENV PATH="/opt/hive/bin:${PATH}"
