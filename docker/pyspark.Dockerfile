FROM jpacerqueira83/spark-k8s:2.4.5

USER spark
### Additional Libraries Loaded as local jars
### delta.io delta-lake
COPY delta-core_2.11-0.6.1.jar /opt/spark/jars

USER root

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    apt-utils \
    python3 \
    python3-dev \
    python3-pip \
    python3-wheel

# Clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s $(which python3) /usr/local/bin/python

RUN python3 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools

RUN python3 -m pip --no-cache-dir install \
    wheel \
    pypandoc \
    pyspark==2.4.5 \
    scipy \
    numpy \ 
    pandas \
    pyarrow \
    pdfminer.six \
    h2o
## included aditional libraries required in pyspark jobs
#
ENV SPARK_EXTRA_CLASSPATH="io.delta:delta-core_2.11:0.6.1,${SPARK_EXTRA_CLASSPATH}"
