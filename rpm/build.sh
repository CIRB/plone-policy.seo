#!/bin/bash
set -e
export QA_RPATHS=$[ 0x0001|0x0002 ]

RPM_VERSION="1.0.${BUILD_NUMBER}"
RPM_NAME=seo-website
HOME=/data
USER=seo

SRC_DIR=$WORKSPACE/src

BUILD_DIR=$WORKSPACE/build
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

# directory structure needed for rpmbuild
RPM_ROOT_DIR=$BUILD_DIR/rpm_root
mkdir $RPM_ROOT_DIR
cd $RPM_ROOT_DIR
mkdir -p BUILD RPMS SRPMS SOURCES tmp

# prepare source before archive
ARCHIVE_DIR=$BUILD_DIR/$RPM_NAME-$RPM_VERSION
mkdir $ARCHIVE_DIR
cp -r $SRC_DIR/* $ARCHIVE_DIR

# make source archive
tar czvf $RPM_ROOT_DIR/SOURCES/$RPM_NAME-$RPM_VERSION.tar.gz --exclude=*.spec -C $BUILD_DIR $RPM_NAME-$RPM_VERSION

# get simple.spec from Rpmizer repository
SIMPLE_SPEC=$BUILD_DIR/simple.spec
wget -O $SIMPLE_SPEC https://raw.github.com/CIRB/Rpmizer/2.2.0/simple.spec --no-check-certificate

rpmbuild --define "name $RPM_NAME" \
    --define "home $HOME" \
    --define "user $USER" \
    --define "version $RPM_VERSION" \
    --define="_topdir $RPM_ROOT_DIR" \
    --define="_tmppath $RPM_ROOT_DIR/tmp" \
    -bb $BUILD_DIR/simple.spec
