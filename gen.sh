#!/bin/bash

set -e
echo 'STARTING';

PROTOBUF_VERSION=3.12.3

case "$OSTYPE" in
  linux*)
    PROTOBUF_PLATFORM=linux-x86_64
    PROTOC=tmp/bin/protoc
    ;;
  win* | msys* | cygwin*)
    PROTOBUF_PLATFORM=win64
    PROTOC=tmp/bin/protoc.exe
    ;;
  darwin*)
    PROTOBUF_PLATFORM=osx-x86_64
    PROTOC=tmp/bin/protoc
    ;;
  *)
    echo "Unknown OSTYPE: $OSTYPE"
    exit 1
esac

# Setup protoc
rm -rf tmp
mkdir tmp
cd tmp
echo "Downloading protobuf tools"
curl -sSL \
  https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protoc-$PROTOBUF_VERSION-$PROTOBUF_PLATFORM.zip \
  --output protobuf.zip
unzip -q protobuf.zip
cd ..

# $PROTOC \
# --jsonschema_out=allow_null_values:. \
# --proto_path=testdata/proto \
# testdata/proto/test.proto

$PROTOC \
--jsonschema_out=allow_null_values:. \
--proto_path=google-cloudevents/proto/ \
google-cloudevents/proto/google/events/cloud/pubsub/v1/data.proto