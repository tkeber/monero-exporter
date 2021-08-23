FROM golang:1.16-buster AS builder

        WORKDIR /workspace

        COPY .git     .git
        COPY go.mod   go.mod
        COPY go.sum   go.sum
        COPY pkg/     pkg/
        COPY cmd/     cmd/

        RUN set -x && CGO_ENABLED=0 GOOS=linux GO111MODULE=on \
                go build -a -v \
			-trimpath \
			-tags osusergo,netgo,static_build \
			-o monero-exporter \
				./cmd/monero-exporter


FROM gcr.io/distroless/base-debian10
        WORKDIR /
        COPY --chown=nonroot:nonroot --from=builder /workspace/monero-exporter .
        USER nonroot:nonroot

        ENTRYPOINT ["/monero-exporter"]
