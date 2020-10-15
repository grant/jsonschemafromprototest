# jsonschemafromprototest

Setup:

```sh
GO111MODULE=on \
go get github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema && \
go install github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema
```

```
git clone git@github.com:googleapis/google-cloudevents.git
```

Gen:

```sh
./gen.sh
```