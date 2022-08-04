FROM golang:alpine
WORKDIR /app/
RUN apk update && apk add git

# checkout the latest tag of jfrog cli
RUN mkdir -p /go/src/github.com/mkaam/netlify-auth \
 && git clone https://github.com/mkaam/netlify-auth /go/src/github.com/mkaam/netlify-auth \
 && cd /go/src/github.com/mkaam/netlify-auth \
 && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

RUN GOOS=linux go install github.com/mkaam/netlify-auth@latest

FROM alpine
COPY --from=0 /go/bin/netlify-auth /usr/bin/

ENTRYPOINT ["netlify-auth"]