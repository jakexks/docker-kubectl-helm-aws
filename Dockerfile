FROM ubuntu:latest as installer
RUN apt-get -y update && apt-get -y install curl openssl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
RUN chmod a+x kubectl

ADD https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get /usr/local/bin/gethelm
RUN chmod a+x /usr/local/bin/gethelm && gethelm -v latest


FROM alpine:3.7

COPY repos /etc/apk/repositories
RUN apk add --update aws-cli@testing git ca-certificates && rm -rf /var/cache/apk/*

COPY --from=installer kubectl /usr/local/bin/kubectl
COPY --from=installer /usr/local/bin/helm /usr/local/bin/helm

