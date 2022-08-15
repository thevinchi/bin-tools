# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:22.04

ADD "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" awscliv2.zip

ENV DEBIAN_FRONTEND=noninteractive
RUN bash <<EOF
apt-get update
apt-get install -y --no-install-recommends unzip groff
rm -rf /var/lib/apt/lists/*
#
# Install AWS-CLI
unzip awscliv2.zip
./aws/install
rm -rf ./aws awscliv2.zip
#
EOF

ARG WORKDIR="/mnt/work" \
    AWS_CONFIG="/mnt/aws"

ENV AWS_CONFIG_FILE="${AWS_CONFIG}/config" \
    AWS_SHARED_CREDENTIALS_FILE="${AWS_CONFIG}/credentials" \
    AWS_PAGER=""

VOLUME [ "${WORKDIR}", "${AWS_CONFIG}" ]
WORKDIR ${WORKDIR}

ENTRYPOINT [ "/usr/local/bin/aws" ]