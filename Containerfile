FROM quay.io/centos/centos:stream9-minimal

RUN microdnf install -y python3.11 python3-pip \
    && microdnf clean all

COPY containerfiles/google-cloud-cli.repo /etc/yum.repos.d/google-cloud-sdk.repo

RUN \
  # epel
    microdnf install -y epel-release \
  # tools
    && microdnf install -y bc wget tar iputils bc wget \
  # parallel
    && microdnf install -y parallel \
  # mc binary
    && wget -q https://dl.min.io/client/mc/release/linux-amd64/mc \
    && chmod +x mc && mv mc /usr/bin/ \
  # azure-cli
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && rpm -i https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm \
    && microdnf install -y azure-cli \
  # azcopy
    && wget -q -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux \
    && tar -xf azcopy_v10.tar.gz --strip-components=1 \
    && rm azcopy_v10.tar.gz \
    && mv azcopy /usr/bin/ \
  # s3cmd and swift client
    && pip install s3cmd python-swiftclient \
  # gsutil
    && microdnf install -y google-cloud-cli \
  # aws cli
    && pip install awscli \
  # clean dnf cache
    && microdnf clean all

COPY ossperf.sh /usr/bin/ossperf

VOLUME /root/testfiles

ENTRYPOINT ["ossperf"]
