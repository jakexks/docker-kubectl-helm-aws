FROM ubuntu:latest as installer
RUN apt-get -y update && apt-get -y install curl git openssl build-essential

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
RUN chmod a+x kubectl

ADD https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get /usr/local/bin/gethelm
RUN chmod a+x /usr/local/bin/gethelm
RUN gethelm -v latest

RUN curl -LO https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.9.3.linux-amd64.tar.gz
RUN export PATH=$PATH:/root/go/bin

RUN mkdir -p ~/.helm/plugins
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git

FROM alpine:3.7

COPY repos /etc/apk/repositories
RUN apk add --update aws-cli@testing git ca-certificates && rm -rf /var/cache/apk/*

COPY --from=installer kubectl /usr/local/bin/kubectl
COPY --from=installer /usr/local/bin/helm /usr/local/bin/helm
COPY --from=installer /root/.helm /root/.helm

