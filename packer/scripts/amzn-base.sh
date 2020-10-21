#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

err_report() {
    echo "Exited with error on line $1"
}
trap 'err_report $LINENO' ERR
IFS=$'\n\t'

echo "# packages install"
yum -y install  amazon-linux-extras \
                bash-completion \
                curl \
                deltarpm \
                device-mapper-persistent-data \
                git \
                jq \
                lvm2 \
                net-tools \
                unzip \
                vim \
                wget \
                yum-plugin-fastestmirror \
                yum-plugin-remove-with-leaves \
                yum-utils \
                yum-versionlock

amazon-linux-extras install kernel-ng docker

systemctl daemon-reload || echo "failed to reload systemd services"
systemctl enable docker.service --now || echo "failed to enable and start docker.service"

usermod -aG docker ec2-user

yum clean all
rm -rf /var/cache/yum
