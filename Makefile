SPACE := $(subst ,, )


install:
	go mod download github.com/yuin/goldmark
	go install -v ./cmd/monero-exporter
	go get -v -u github.com/quasilyte/go-ruleguard/dsl

run:
	monero-exporter \
		--monero-addr=http://localhost:18081 \
		--bind-addr=:9000

test:
	go test ./...

lint:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run \
		--config=.golangci.yaml


table-of-contents:
	doctoc --notitle ./README.md


.images.lock.yaml: .images.yaml
	kbld -f $< --lock-output $@
.PHONY: .images.lock.yaml

examples/docker-compose.yaml: .images.lock.yaml ./examples/docker-compose.base.yaml
	kbld --images-annotation=false $(subst $(SPACE), -f , $^) > $@
