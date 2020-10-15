#!/bin/bash

set -e
echo '# STARTING';

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

# Clone googleapis dependency
if [ ! -d "googleapis" ] ; then
  git clone https://github.com/googleapis/googleapis
fi

# Test works
# $PROTOC \
# --jsonschema_out=allow_null_values:out \
# --proto_path=testdata/proto \
# testdata/proto/test.proto

# Pub/Sub works
# $PROTOC \
# --jsonschema_out=allow_null_values:out \
# --proto_path=google-cloudevents/proto/ \
# google-cloudevents/proto/google/events/cloud/pubsub/v1/data.proto

# Doesn't work because crusty stackoverflows
# $PROTOC \
# --jsonschema_out=allow_null_values:out \
# --proto_path=google-cloudevents/proto/ \
# --proto_path=googleapis/ \
# google-cloudevents/proto/google/events/cloud/audit/v1/data.proto

# Works if you change "google.protobuf.Struct" with "map<string, string>"
# $PROTOC \
# --jsonschema_out=allow_null_values:out \
# --proto_path=google-cloudevents/proto/ \
# --proto_path=googleapis/ \
# google-cloudevents/proto/google/events/firebase/auth/v1/data.proto

# Works
# $PROTOC \
# --jsonschema_out=allow_null_values:out \
# --proto_path=google-cloudevents/proto/ \
# --proto_path=googleapis/ \
# google-cloudevents/proto/google/events/firebase/auth/v1/data.proto

# Not allowing allow_null_values creates a better output
# $PROTOC \
# --jsonschema_out=out \
# --proto_path=google-cloudevents/proto/ \
# --proto_path=googleapis/ \
# google-cloudevents/proto/google/events/firebase/auth/v1/data.proto

# Scheduler proto needs fixing
# $PROTOC \
# --jsonschema_out=out \
# --proto_path=google-cloudevents/proto/ \
# --proto_path=googleapis/ \
# google-cloudevents/proto/google/events/cloud/scheduler/v1/data.proto

$PROTOC \
--jsonschema_out=out \
--proto_path=google-cloudevents/proto/ \
--proto_path=googleapis/ \
google-cloudevents/proto/google/events/cloud/storage/v1/data.proto

# Rename files: Use .json rather than .jsonschema
for f in out/*.jsonschema; do 
    mv -- "$f" "${f%.jsonschema}.json"
done