FROM golang:1.5

RUN mkdir -p /go/src/github.com/mackerelio
ADD ./mackerel-agent /go/src/github.com/mackerelio/mackerel-agent
WORKDIR /go/src/github.com/mackerelio/mackerel-agent
RUN make deps
CMD bash -c "GOOS=linux GOARCH=amd64 GOARM=5 CGO_ENABLED=0 make build && cp ./build/mackerel-agent /host/_mackerel-agent"
