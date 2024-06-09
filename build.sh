#!/bin/bash

set -e

VERSION='0.0.0'
RELEASE='0'

rm -rf ~/rpmbuild

export GOPATH=~/go
export PATH=${PATH}:${GOPATH}/bin

mkdir -p ${GOPATH}/{bin,pkg,src}

sudo dnf install npm git make golang rpmdevtools -y

if [ ! -d mysqld_exporter ]; then
  git clone https://github.com/prometheus/alertmanager
fi

cd alertmanager
git pull
VERSION=$(git describe | grep -o '[0-9]\{0,\}\.[0-9]\{1,\}.[0-9]\{1,\}')
RELEASE=$(git describe | grep -o '\-[0-9]\{1,\}\-' | grep -o '[0-9]\{1,\}')

rpmdev-setuptree

# Download project dependencies
#go mod tidy
cd ..

mkdir -p alertmanager/dep
cp dep/prometheus-alertmanager alertmanager/dep
cp dep/prometheus-alertmanager.service alertmanager/dep
cp dep/alertmanager.yml alertmanager/dep

tar czf prometheus-alertmanager-${VERSION}.tar.gz alertmanager --transform s/alertmanager/prometheus-alertmanager-${VERSION}/

mv prometheus-alertmanager-${VERSION}.tar.gz ~/rpmbuild/SOURCES

rpmbuild -ba --define "version_ ${VERSION}" --define "release_ ${RELEASE}" alertmanager.spec

cp ~/rpmbuild/RPMS/x86_64/*.rpm /var/www/repo/KasperWPS/
touch /var/www/repo/KasperWPS/.runtask
